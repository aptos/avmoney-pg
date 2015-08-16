class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :invoice, index: true
      t.integer :invoice_number
      t.references :client, index: true
      t.string :project
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :notes
    end
  end
end
