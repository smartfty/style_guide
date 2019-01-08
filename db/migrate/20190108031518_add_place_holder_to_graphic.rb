class AddPlaceHolderToGraphic < ActiveRecord::Migration[5.2]
  def change
    add_column :graphics, :place_holder, :string
  end
end
