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

  describe "update" do
    it "updates an existing client" do
      client = FactoryGirl.create(:client)
      post :update, {id: client.id, client: { rate: 150}}
      assigns(:client)['rate'].should == 150
    end

    it "returns error when client not found" do
      FactoryGirl.create(:client)
      post :update, {id: 9999, client: { rate: 150}}
      (JSON response.body)['error'].should eq "Couldn't find Client with 'id'=9999"
    end
  end

  describe "destroy" do
    it "destroys client" do
      client = FactoryGirl.create(:client)
      delete :destroy, id: client.id
      (JSON response.body)['status'].should == 'Deleted'
    end
  end

  describe "projects" do

    before do
      @client = FactoryGirl.create(:client)
      @project = FactoryGirl.create(:project, client: @client)
      @project2 = FactoryGirl.create(:project, client: @client, name: "Second Project")
      FactoryGirl.create(:activity, client: @client, project: @project)
      FactoryGirl.create(:expense, client: @client, project: @project)
      FactoryGirl.create(:activity, client: @client, project: @project2, notes: 'More work', hours: 2.25)
    end

    it "returns all projects for a client" do
      get :projects, id: @client.id
      assigns(:projects).size.should == 2
    end

    describe "projects_report" do
      it "returns activities summary by project" do
        get :projects_report, id: @client.id
        assigns(:projects).first['activities'].should eq({:hours=>2.25, :hours_amount=>303.75, :expenses=>0.0, :tax=>0.0, :total=>303.75})
      end
    end

    describe "update project" do
      it "creates new project with work order, po number and cap" do
        post :update_project, { id: @client.id, project: { id: @project.id, name: 'groovy project', cap: 5000}}
        assigns(:project).name.should eq 'groovy project'
      end

      it "updates existing project with work order, po number and cap" do
        post :update_project, { id: @client.id, project: { id: @project.id, po_number: "newpo123", wo_number: "newwoABC", cap: 5000}}
        (JSON response.body).should eq ({"id"=>@project.id, "name"=>"Kitchen Remodel", "wo_number"=>"newwoABC", "po_number"=>"newpo123", "cap"=>5000, "client_id"=>@client.id})
      end
    end
  end

  describe "next_invoice" do
    it "returns next invoice for client" do
      client = FactoryGirl.create(:client)
      FactoryGirl.create(:invoice, client: client, invoice_number: 1)
      get :next_invoice, id: client.id
      response.body.should eq "2"
    end
  end
end