class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :invoice_number
      t.string :po_number
      t.string :wo_number
      t.references :client, index: true
      t.float :hours_sum
      t.decimal :hours_amount, :precision => 8, :scale => 3
      t.decimal :expenses, :precision => 8, :scale => 2
      t.float :tax
      t.decimal :invoice_total, :precision => 8, :scale => 2
      t.text :activities, array: true, default: []
      t.json :client_data
      t.references :project, index: true
      t.string :status
      t.date :open_date
      t.date :paid_date
      t.decimal :paid, :precision => 8, :scale => 2
    end
  end
end
