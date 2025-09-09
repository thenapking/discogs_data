class CreateMasterReleasesGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :master_releases_genres do |t|
      t.references :master_release, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
