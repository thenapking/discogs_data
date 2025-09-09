class CreateMasterReleasesStyles < ActiveRecord::Migration[8.0]
  def change
    create_table :master_releases_styles do |t|
      t.references :master_release, null: false, foreign_key: true
      t.references :style, null: false, foreign_key: true

      t.timestamps
    end
  end
end
