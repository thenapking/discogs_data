require 'nokogiri'

namespace :import do
  desc "Import MasterRelease data from XML (with genres and styles)"
  task master_releases: :environment do
    file_path = 'tmp/data/discogs_masters.xml'
    BATCH_SIZE = 250
    buffer = []
    total = 0

    puts "🚀 Starting import from #{file_path}..."
    puts "🔍 Streaming and batching records..."

    # Cache for genre/style lookups
    genre_cache = {}
    style_cache = {}

    # Preload existing genres/styles into cache
    Genre.pluck(:name, :id).each { |name, id| genre_cache[name] = id }
    Style.pluck(:name, :id).each { |name, id| style_cache[name] = id }

    class MasterReleaseHandler < Nokogiri::XML::SAX::Document
      def initialize(buffer:, batch_size:, genre_cache:, style_cache:)
        @buffer = buffer
        @batch_size = batch_size
        @genre_cache = genre_cache
        @style_cache = style_cache

        @record = {}
        @current_tag = nil
        @inside_master = false
        @genres = []
        @styles = []
        @count = 0
      end

      def start_element(name, attrs = [])
        if name == "master"
          @inside_master = true
          @record = {}
          @genres = []
          @styles = []
          @record["discogs_id"] = attrs.to_h["id"]
        elsif @inside_master
          @current_tag = name
        end
      end

      def characters(string)
        return unless @inside_master && @current_tag

        value = string.strip
        return if value.empty?

        case @current_tag
        when "genre"
          @genres << value unless @genres.include?(value)
        when "style"
          @styles << value unless @styles.include?(value)
        else
          @record[@current_tag] ||= ""
          @record[@current_tag] << value
        end
      end

      def end_element(name)
        if name == "master"
          # Build MasterRelease hash
          master_release = {
            discogs_id:     @record["discogs_id"]&.to_i,
            main_release:   @record["main_release"],
            artists:        @record["artists"],
            artist:         @record["artist"],
            name:           @record["name"],
            join:           @record["join"],
            year:           @record["year"]&.to_i,
            title:          @record["title"],
            data_quality:   @record["data_quality"],
            videos:         @record["videos"],
            video:          @record["video"],
            description:    @record["description"],
            anv:            @record["anv"],
            notes:          @record["notes"]
          }

          @buffer << { release: master_release, genres: @genres.dup, styles: @styles.dup }
          @count += 1

          if @buffer.size >= @batch_size
            flush_batch
          end

          @inside_master = false
          @current_tag = nil
        elsif @inside_master
          @current_tag = nil
        end
      end

      def flush_batch
        releases_data = @buffer.map { |h| h[:release] }
        inserted = MasterRelease.insert_all(releases_data, returning: [:id, :discogs_id])

        # Build discogs_id => DB id map
        id_map = inserted.to_h { |row| [row["discogs_id"].to_s, row["id"]] }

        genre_links = []
        style_links = []

        @buffer.each do |item|
          db_id = id_map[item[:release][:discogs_id].to_s]
          next unless db_id

          item[:genres].each do |gname|
            genre_id = @genre_cache[gname] ||= Genre.find_or_create_by!(name: gname).id
            genre_links << { genre_id: genre_id, master_release_id: db_id }
          end

          item[:styles].each do |sname|
            style_id = @style_cache[sname] ||= Style.find_or_create_by!(name: sname).id
            style_links << { style_id: style_id, master_release_id: db_id }
          end
        end

        MasterReleasesGenre.insert_all(genre_links) if genre_links.any?
        MasterReleasesStyle.insert_all(style_links) if style_links.any?

        puts "💾 Inserted #{releases_data.size} master_releases, #{genre_links.size} genres, #{style_links.size} styles..."

        @buffer.clear
      end

      def finalize
        flush_batch if @buffer.any?
        puts "✅ Finished parsing #{@count} records."
      end
    end

    begin
      handler = MasterReleaseHandler.new(
        buffer: buffer,
        batch_size: BATCH_SIZE,
        genre_cache: genre_cache,
        style_cache: style_cache
      )

      parser = Nokogiri::XML::SAX::Parser.new(handler)
      File.open(file_path) { |file| parser.parse(file) }
      handler.finalize
    rescue => e
      puts "❌ Error: #{e.class} - #{e.message}"
      puts e.backtrace.first(10)
    end

    puts "🎉 Import complete."
  end
end
