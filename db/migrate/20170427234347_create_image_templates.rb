class CreateImageTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :image_templates do |t|
      t.integer :column
      t.integer :row
      t.integer :height_in_lines
      t.string :image_path
      t.string :caption_title
      t.string :caption
      t.integer :position
      t.integer :page_columns
      t.integer :article_id
      t.integer :publication_id

      t.timestamps
    end
  end
end
