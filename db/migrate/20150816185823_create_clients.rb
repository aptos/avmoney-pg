class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.float :rate
      t.float :tax_rate
      t.string :address
      t.string :deliveries
      t.string :contact
      t.string :email
      t.string :phone
      t.string :cell
      t.string :contact2
      t.string :email2
      t.string :phone2
      t.string :cell2
      t.text :active_projects, array: true, default: []
      t.text :archived_projects, array: true, default: []
      t.integer :base_invoice_id
      t.boolean :archived
    end

    change_column_default :clients, :base_invoice_id, 1
    change_column_default :clients, :archived, false
  end
end
