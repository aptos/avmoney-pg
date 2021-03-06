class Payment < ActiveRecord::Base
  belongs_to :client
  belongs_to :invoice

  # property :_id, String
  # property :invoice_id, String
  # property :client_id, String
  # property :client_name, String
  # property :invoice_number, Integer
  # property :project, String
  # property :amount, Float
  # property :notes, String
  # property :date, Date

  # timestamps!

  # design do
  #   view :by_client_name
  #   view :summary,
  #   :map =>
  #   "function(doc) { if (doc.type == 'Payment') {
  #     emit([doc.date, doc.client_name], {date: doc.date, invoice: doc.invoice_number, client_id: doc.client_id, client_name: doc.client_name, project: doc.project, type: 'payment', notes: doc.notes, amount: doc.amount});
  #   }
  #   };"
  # end

  # design do
  #   view :by_invoice_id,
  #  :map =>
  #  "function(doc) {
  #     if (doc['type'] === 'Payment') {
  #       emit(doc.invoice_id, doc.amount);
  #     }
  #   }",
  #   :reduce =>
  #   '_sum'
  # end
end