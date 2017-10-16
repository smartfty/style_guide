class CreateGraphicRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :graphic_requests do |t|
      t.date :date
      t.string :title
      t.string :requester
      t.string :person_in_charge
      t.string :status
      t.text :description

      t.timestamps
    end
  end
end
