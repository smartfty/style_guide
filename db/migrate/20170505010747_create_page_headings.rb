class CreatePageHeadings < ActiveRecord::Migration[5.0]
  def change
    create_table :page_headings do |t|
      t.integer :page_number
      t.string :section_name
      t.string :date
      t.text :layout
      t.references :publication, foreign_key: true

      t.timestamps
    end
  end
end
