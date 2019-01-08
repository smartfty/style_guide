class AddPlaceHolderToImage < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :place_holder, :string
  end
end
