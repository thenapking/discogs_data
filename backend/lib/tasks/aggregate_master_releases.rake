namespace :aggregate do
  desc "Aggregate master release counts per year for each style and genre"
  task master_releases: :environment do
    puts "🧮 Aggregating style summaries..."

    StyleSummary.delete_all
    GenreSummary.delete_all

    Style.joins(:master_releases)
         .where.not('master_releases.year = 0')
         .group('styles.id', 'master_releases.year')
         .select('styles.id AS style_id, master_releases.year, COUNT(*) AS total')
         .each do |row|
            StyleSummary.create!(
              style_id: row.style_id,
              year: row.year,
              count: row.total
            )
         end

    puts "✅ Styles done."
    puts "🧮 Aggregating genre summaries..."

    Genre.joins(:master_releases)
         .where.not('master_releases.year = 0')
         .group('genres.id', 'master_releases.year')
         .select('genres.id AS genre_id, master_releases.year, COUNT(*) AS total')
         .each do |row|
            GenreSummary.create!(
              genre_id: row.genre_id,
              year: row.year,
              count: row.total
            )
         end

    puts "✅ Genres done."
    puts "🎉 Aggregation complete!"
  end
end
