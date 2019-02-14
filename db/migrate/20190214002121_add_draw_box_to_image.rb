class AddDrawBoxToImage < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :draw_box, :boolean
  end
end
