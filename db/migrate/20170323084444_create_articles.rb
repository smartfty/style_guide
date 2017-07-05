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
      t.string :subject_head
      t.boolean :on_left_edge
      t.boolean :on_right_edge
      t.boolean :is_front_page
      t.boolean :top_story
      t.boolean :top_position
      t.integer :page_columns
      t.integer :section_id, foreign_key: true
      t.timestamps
    end
  end
end
