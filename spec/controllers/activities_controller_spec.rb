require 'spec_helper'

describe ActivitiesController, :type => :controller do

  before do
    @client = FactoryGirl.create(:client, name: "AAA Auto")
    @client2 = FactoryGirl.create(:client, name: "Big Auto")
    @client3 = FactoryGirl.create(:client, name: "1st Auto")

    @project = FactoryGirl.create(:project, client: @client)
    @project2 = FactoryGirl.create(:project, client: @client2)
    FactoryGirl.create(:activity, client: @client, project: @project)
    FactoryGirl.create(:expense, client: @client, project: @project)

    FactoryGirl.create(:activity, client: @client2, project: @project2, notes: 'More work', hours: 2.25)
    FactoryGirl.create(:expense, client: @client2, project: @project2)

  end

  describe "index" do
    it "gets all activities as summary" do
      get :index
      assigns(:activities).size.should == 4
    end

    it "gets activities for client" do
      get :index, client_id: @client.id
      assigns(:activities).size.should == 2
    end

    it "gets Paid status activities for client" do
      FactoryGirl.create(:activity, client: @client, project: @project, status: 'Paid')
      get :index, client_id: @client.id, status: 'Paid'
      assigns(:activities).first['status'].should == 'Paid'
    end

    it "returns csv format including invoice ids" do
      invoice = FactoryGirl.create(:invoice, client: @client, project: @project)
      FactoryGirl.create(:activity, client: @client, project: @project, status: 'Paid', invoice_id: invoice.id)
      get :index, format: "csv"
      assigns(:activities).size.should eq 6
      response.body.split("\n").size.should eq 6
      response.body.split("\n").last.should match "Pick Colors,1.625,,Paid,3"
    end
  end

end