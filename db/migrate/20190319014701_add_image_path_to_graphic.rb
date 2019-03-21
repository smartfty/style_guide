class AddImagePathToGraphic < ActiveRecord::Migration[5.2]
  def change
    add_column :graphics, :reporter_image_path, :string
  end
end
