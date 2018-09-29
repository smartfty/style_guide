class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.references :user, foreign_key: true
      t.references :working_article, foreign_key: true
      t.string :reporter
      t.string :group
      t.date :date
      t.string :title
      t.string :subtitle
      t.string :body
      t.string :quote
      t.string :status
      t.integer :char_count
      t.boolean :published
      t.string :path

      t.timestamps
    end
  end
end
