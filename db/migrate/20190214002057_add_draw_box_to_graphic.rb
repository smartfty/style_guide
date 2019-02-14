class AddDrawBoxToGraphic < ActiveRecord::Migration[5.2]
  def change
    add_column :graphics, :draw_box, :boolean
    add_column :graphics, :title, :string
    add_column :graphics, :description, :text
  end
end
