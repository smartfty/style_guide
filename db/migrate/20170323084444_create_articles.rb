class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.integer :column
      t.integer :row
      t.integer :order
      t.integer :profile
      t.string :title
      t.string :subtitle
      t.text :body
      t.string :reporter
      t.string :email
      t.string :personal_image
      t.string :image
      t.string :quote
      t.string :name_tag
      t.boolean :is_front_page
      t.boolean :top_story
      t.boolean :top_position
      t.string :kind
      t.integer :page_columns
      t.references :publication, foreign_key: true
      t.timestamps
    end
  end
end
