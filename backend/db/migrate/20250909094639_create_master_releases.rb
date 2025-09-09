class CreateMasterReleases < ActiveRecord::Migration[8.0]
  def change
    create_table :master_releases do |t|
      t.integer :discogs_id
      t.string :masters
      t.string :master
      t.string :main_release
      t.string :artists
      t.string :artist
      t.string :name
      t.string :join
      t.string :genres
      t.string :genre
      t.string :styles
      t.string :style
      t.integer :year
      t.string :title
      t.string :data_quality
      t.string :videos
      t.string :video
      t.string :description
      t.string :anv
      t.string :notes

      t.timestamps
    end
  end
end
