class AddSubcategoryCodeToStories < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :subcategory_code, :string
  end
end
