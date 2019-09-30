class CreateArticleSubcategory < ActiveRecord::Migration[5.2]
  def change
    create_table :article_subcategories do |t|
      t.string :name
      t.string :code
      t.references :article_category, foreign_key: true
    end
  end
end
