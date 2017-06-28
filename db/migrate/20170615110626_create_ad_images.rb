class CreateAdImages < ActiveRecord::Migration[5.0]
  def change
    create_table :ad_images do |t|
      t.string :ad_type
      t.integer :column
      t.integer :row
      t.string :image_path
      t.string :advertiser
      t.integer :page_number
      t.integer :article_number
      t.integer :working_article_id
      t.integer :issue_id

      t.timestamps
    end
  end
end
