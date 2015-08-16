require 'spec_helper'

describe Activity do
  it "has a valid factory" do
    FactoryGirl.create(:activity).should be_valid
  end

  it "has a client association" do
    client = FactoryGirl.create(:client)
    FactoryGirl.create(:activity, client: client)
    client.activities.first.client_id.should == client.id
  end

  it "has a project association" do
    client = FactoryGirl.create(:client)
    project = FactoryGirl.create(:project, client: client)
    FactoryGirl.create(:activity, client: client, project: project)
    client.activities.first.project_id.should == project.id
  end

  it "returns project summary" do
    client = FactoryGirl.create(:client)
    project = FactoryGirl.create(:project, client: client)
    project2 = FactoryGirl.create(:project, client: client, name: "Second Project")
    FactoryGirl.create(:activity, client: client, project: project)
    FactoryGirl.create(:expense, client: client, project: project)
    FactoryGirl.create(:activity, client: client, project: project, notes: 'More work', hours: 2.25)
    FactoryGirl.create(:activity, client: client, project: project2, notes: 'More more work', hours: 12.0)

    Activity.project_summary(client.id, project.id).should eq({:hours=>3.875, :hours_amount=>523.125, :expenses=>500.0, :tax=>47.5, :total=>1070.63})
  end

end
