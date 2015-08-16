class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :invoice_number
      t.string :po_number
      t.string :wo_number
      t.references :client, index: true
      t.float :hours_sum
      t.decimal :hours_amount
      t.decimal :expenses
      t.float :tax
      t.decimal :invoice_total
      t.text :activities, array: true, default: []
      t.json :client_data
      t.references :project, index: true
      t.string :status
      t.date :open_date
      t.date :paid_date
      t.decimal :paid
    end
  end
end
