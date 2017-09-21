class CreateAdBoxes < ActiveRecord::Migration[5.0]
  def change
    create_table :ad_boxes do |t|
      t.integer :grid_x
      t.integer :grid_y
      t.integer :column
      t.integer :row
      t.string :ad_type
      t.string :advertiser
      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end
