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

  describe "show" do
    it "gets one activity" do
      activity = FactoryGirl.create(:activity, client: @client, project: @project)
      get :show, id: activity.id
      assigns(:activity).client_name.should eq activity.client_name
    end

    it "returns not found when missing" do
      get :show, id: 999
      response.status.should eq 404
    end
  end

  describe "create" do
    it "creates a new activity with empty project" do
      activity = FactoryGirl.attributes_for(:activity)
      post :create, { activity: activity, client_id: @client.id, format: :json }
      assigns(:activity).notes.should eq 'Pick Colors'
    end

    it "creates a new activity with an existing project" do
      activity = FactoryGirl.attributes_for(:activity)
      post :create, { activity: activity, client_id: @client.id, project: @project.name, format: :json }
      assigns(:activity).project_id.should eq @project.id
    end

    it "creates a new activity with a new project" do
      activity = FactoryGirl.attributes_for(:activity)
      post :create, { activity: activity, client_id: @client.id, project: "Fresh New Project", format: :json }
      assigns(:activity).project.name.should eq "Fresh New Project"
    end
  end

  describe "update" do
    it "updates an activity" do
      activity = FactoryGirl.create(:activity, client: @client)
      activity.notes = "These notes are New!"
      post :update, { id: activity.id, activity: activity.serializable_hash, format: :json }
      assigns(:activity).notes.should eq "These notes are New!"
    end

    it "updates an activity with an existing project" do
      activity = FactoryGirl.create(:activity, client: @client, project: @project)
      activity.notes = "These notes are New!"
      post :update, { id: activity.id, activity: activity.serializable_hash,  format: :json }
      assigns(:activity).project_id.should eq @project.id
    end

    it "updates activity with a new project" do
      activity = FactoryGirl.create(:activity, client: @client, project: @project)
      post :update, { id: activity.id, activity: activity.serializable_hash, project: "Fresh New Project",  format: :json }
      assigns(:activity).project.name.should eq "Fresh New Project"
    end
  end

  describe "destroy" do
    it "can destroy an activity" do
      activity = FactoryGirl.create(:activity, client: @client)
      delete :destroy, { id: activity.id, format: :json }
      (JSON response.body).should eq({"status"=>"Deleted"})
    end

    it "does not destroy an activity with status which is not Active" do
      activity = FactoryGirl.create(:activity, client: @client, status: 'Paid')
      delete :destroy, { id: activity.id, format: :json }
      response.status.should eq 400
      (JSON response.body).should eq({"error"=>"Only Active activities may be removed"})
    end
  end

end