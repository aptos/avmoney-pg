require 'spec_helper'

describe SessionsController, :type => :controller do

  describe "create" do
    it "logs in existing user" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
      @user = FactoryGirl.create(:user, :email => OmniAuth.config.mock_auth[:google][:info][:email])
      post :create, provider: 'google'
      session[:user_id].should == @user.id
    end

    it "creates user" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
      post :create, provider: 'google'
      session[:user_id].should_not be_nil
    end
  end

end