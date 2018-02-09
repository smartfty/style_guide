class CreateReporters < ActiveRecord::Migration[5.1]
  def change
    create_table :reporters do |t|
      t.string :name
      t.string :email
      t.string :division
      t.string :title

      t.timestamps
    end
  end
end
