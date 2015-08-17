require 'spec_helper'

describe Payment do
  it "has a valid factory" do
    FactoryGirl.create(:payment).should be_valid
  end

  it "has a client association" do
    client = FactoryGirl.create(:client)
    FactoryGirl.create(:payment, client: client)
    client.payments.first.client_id.should == client.id
  end

  it "has a project association" do
    client = FactoryGirl.create(:client)
    project = FactoryGirl.create(:project, client: client)
    FactoryGirl.create(:payment, client: client, project: project.name)
    client.payments.first.project.should == project.name
  end
end