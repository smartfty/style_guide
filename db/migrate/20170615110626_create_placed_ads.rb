class CreatePlacedAds < ActiveRecord::Migration[5.0]
  def change
    create_table :placed_ads do |t|
      t.string :ad_type
      t.integer :column
      t.integer :row
      t.string :image_path
      t.string :advertiser
      t.integer :order
      t.integer :page_id
      t.integer :issue_id

      t.timestamps
    end
  end
end
