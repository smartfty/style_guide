class AddSlugToIssue < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :slug, :string
  end
end
