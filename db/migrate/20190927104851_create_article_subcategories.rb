class CreateArticleSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :article_subcategories do |t|
      t.string :name
      t.string :code
      t.references :article_categories, foreign_key: true
      t.timestamps
    end
  end
end
