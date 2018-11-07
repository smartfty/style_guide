class AddSubtileStyleToWorkingArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :working_articles, :subtitle_style, :string
  end
end
