class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :client, index: true
      t.string :client_name
      t.references :project, index: true
      t.string :notes
      t.date :date
      t.float :hours
      t.float :rate
      t.decimal :expense, :precision => 8, :scale => 2
      t.float :tax_rate
      t.decimal :tax_paid, :precision => 8, :scale => 2
      t.string :status
      t.references :invoice, index: true
    end

    change_column_default :activities, :status, 'Active'
  end
end
