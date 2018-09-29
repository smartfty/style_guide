class AddCellToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cell, :string
    add_column :users, :title, :string
    add_column :users, :reporter_group_id, :integer
  end
end
