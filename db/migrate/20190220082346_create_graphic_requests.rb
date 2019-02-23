class CreateGraphicRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :graphic_requests do |t|
      t.date :date
      t.references :user, foreign_key: true
      t.string :designer
      t.text :request
      t.text :data
      t.integer :status

      t.timestamps
    end
  end
end
