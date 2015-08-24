class Client < ActiveRecord::Base
  validates_uniqueness_of :name, :case_sensitive => false, :message => "We already have client with that name"

  has_many :projects
  has_many :invoices
  has_many :activities
  has_many :payments

  # property :_id, String
  # property :name, String
  # property :rate, Float
  # property :tax_rate, Float
  # property :address, String
  # property :deliveries, String
  # property :contact, String
  # property :email, String
  # property :phone, String
  # property :cell, String
  # property :contact2, String
  # property :email2, String
  # property :phone2, String
  # property :cell2, String
  # property :projects, [String]
  # property :base_invoice_id, Integer, default: 1
  # property :archived_projects, [String]
  # property :archived, TrueClass, default: false
  # timestamps!

  # design do
  #   view :by_name
  # end

  def next_invoice
    return base_invoice_id if invoices.empty?

    missing = (base_invoice_id..invoices.last.invoice_number).to_a - invoices.collect(&:invoice_number)
    if missing.empty?
      return invoices.last.invoice_number + 1
    else
      return missing[0]
    end
  end

  def find_or_create project_name
    return unless project_name.strip.length >= 1
    if project = self.projects.where(name: project_name).first
      return project
    end

    self.active_projects.push(project_name.strip).uniq!
    self.save
    project = self.projects.create({ name: project_name })

    return project
  end

  # def invoice_stats
  #   i = Invoice.by_client_id_and_status.startkey([self._id]).endkey([self._id,{}]).reduce.group_level(2).rows
  #   i.each {|r| @stats[r["key"][1]] = r["value"]}
  #   @stats
  # end

end