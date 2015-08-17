require 'spec_helper'

describe ClientsController, :type => :controller do

  describe "index" do

    it "returns index with one client" do
      FactoryGirl.create(:client)
      get :index
      assigns(:clients).size.should eq 1
    end

    it "returns sorted index with multiple clients" do
      FactoryGirl.create(:client, name: "AAA Auto")
      FactoryGirl.create(:client, name: "Big Auto")
      FactoryGirl.create(:client, name: "1st Auto")

      get :index
      (JSON response.body).map{|x| x['name']}.should eq ["1st Auto", "AAA Auto", "Big Auto"]
    end

    it "hides archived clients" do
      FactoryGirl.create(:client, name: "AAA Auto")
      FactoryGirl.create(:client, name: "Big Auto", archived: true)
      FactoryGirl.create(:client, name: "1st Auto")

      get :index, active: true
      assigns(:clients).size.should eq 2
    end
  end

  describe "show" do
    it "returns matching client" do
      client = FactoryGirl.create(:client, name: "AAA Auto")
      FactoryGirl.create(:client, name: "Big Auto")

      get :show, id: client.id
      assigns(:client).should eq client
    end

    it "returns error for no matching client" do
      get :show, id: 999999
      response.status.should eq 404
    end
  end

  describe "create" do
    it "creates a new client" do
      client = FactoryGirl.attributes_for(:client)
      post :create, { client: client, format: :json }
      assigns(:client)['name'].should client['name']
    end
  end
end