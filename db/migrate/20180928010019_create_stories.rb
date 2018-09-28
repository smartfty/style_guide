class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.references :user, foreign_key: true
      t.references :working_article, foreign_key: true
      t.string :title
      t.string :subtile
      t.text :body
      t.text :quoute
      t.string :status
      t.integer :char_count
      t.boolean :published
      t.string :path
      t.string :section

      t.timestamps
    end
  end
end
