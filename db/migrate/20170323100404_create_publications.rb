class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications do |t|
      t.string :name
      t.string :paper_size
      t.float :width
      t.float :height
      t.float :left_margin
      t.float :top_margin
      t.float :right_margin
      t.float :bottom_margin
      t.integer :lines_per_grid
      t.float :divider
      t.float :gutter
      t.integer :page_count
      t.text :section_names
      t.text :page_columns
      t.integer :row

      t.timestamps
    end
  end
end
