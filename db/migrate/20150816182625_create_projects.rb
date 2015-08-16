class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :wo_number
      t.string :po_number
      t.integer :cap
      t.references :client, index: true
    end
  end
end
