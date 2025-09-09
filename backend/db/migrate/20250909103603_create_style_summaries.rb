class CreateStyleSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :style_summaries do |t|
      t.references :style, null: false, foreign_key: true
      t.integer :year
      t.integer :count

      t.timestamps
    end

    add_index :style_summaries, [:style_id, :year]
  end
end
