class CreateGenreSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :genre_summaries do |t|
      t.references :genre, null: false, foreign_key: true
      t.integer :year
      t.integer :count

      t.timestamps
    end

    add_index :genre_summaries, [:genre_id, :year]
  end
end
