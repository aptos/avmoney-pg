require 'spec_helper'

describe Client do
  it "has a valid factory" do
    FactoryGirl.create(:client).should be_valid
  end

  it "next_invoice returns base_invoice_id when no invoices exist" do
    client = FactoryGirl.create(:client)
    client.next_invoice.should == 1
  end

  it "next_invoice returns next number when invoices exist" do
    client = FactoryGirl.create(:client)
    FactoryGirl.create(:invoice, client: client, invoice_number: 1)
    client.next_invoice.should == 2
  end

  it "next_invoice returns missing number when invoices list has a hole" do
    client = FactoryGirl.create(:client)
    [1,2,3,5,6].each{|id| FactoryGirl.create(:invoice, client: client, invoice_number: id)}
    client.next_invoice.should == 4
  end
end