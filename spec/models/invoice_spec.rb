require 'spec_helper'

describe Invoice do
  it "has a valid factory" do
    FactoryGirl.create(:invoice).should be_valid
  end

  it "has a client association" do
    client = FactoryGirl.create(:client)
    FactoryGirl.create(:invoice, client: client)
    client.invoices.first.client_id.should == client.id
  end

  it "has a project association" do
    client = FactoryGirl.create(:client)
    project = FactoryGirl.create(:project, client: client)
    FactoryGirl.create(:invoice, client: client, project: project)
    client.invoices.first.project_id.should == project.id
  end

  it "validates_uniqueness_of invoice_number" do
    client = FactoryGirl.create(:client)
    invoice = FactoryGirl.create(:invoice, client: client)
    reused = FactoryGirl.build(:invoice, client: client, invoice_number: invoice.invoice_number)
    reused.should_not be_valid
  end

  it "returns a map of invoice id to invoice_number" do
    client = FactoryGirl.create(:client)
    FactoryGirl.create(:invoice, client: client)
    id = Invoice.all.first.id
    Invoice.map.should eq({ id => 3 })
  end

  it "can update_totals" do
    client = FactoryGirl.create(:client)
    activities = []
    activities.push FactoryGirl.create(:activity, client: client)
    activities.push FactoryGirl.create(:activity, client: client, notes: 'More work', hours: 2.25)
    activities.push FactoryGirl.create(:expense, client: client)
    invoice = FactoryGirl.create(:invoice, client: client, activities: activities  )

    invoice.update_totals

    invoice.hours_sum.should === 3.875
    invoice.hours_amount.to_f.should === 523.125
    invoice.expenses.to_f.should === 500.0
    invoice.tax.should === 47.5
    invoice.invoice_total.to_f.should === 1070.625
  end
end