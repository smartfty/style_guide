class CreateArticleCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :article_categories do |t|
      t.string :name
      t.string :code
    end
  end
end
