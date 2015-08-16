require 'spec_helper'

describe User do
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end

  describe "omniauth" do
    it "from_omniauth finds existing user" do
      user = FactoryGirl.create(:user)
      auth = OmniAuth::AuthHash.new({
        :provider => 'google',
        :info => {
          :email => 'zoevollersen@gmail.com',
          :name => 'Zoe Vollersen'
          },
        :credentials => {
          "token" => "ya29.tgBWkugGIHHikdLmiyUSvpPB3r8wYwe_05FOwVUKyJ7szLpKI-UlaubMXneofG7TmDyT6yDi4SeYdQ",
          "expires_at" => 1415304668,
          "expires" => true
        }
        })
      user = User.from_omniauth(auth)
      user.should_not be_nil
    end

    it "creates with omniauth" do
      auth = OmniAuth::AuthHash.new({
        :provider => 'google',
        :info => {
          :email => 'zoevollersen@gmail.com',
          :name => 'Zoe Vollersen'
          },
        :credentials => {
          "token" => "ya29.tgBWkugGIHHikdLmiyUSvpPB3r8wYwe_05FOwVUKyJ7szLpKI-UlaubMXneofG7TmDyT6yDi4SeYdQ",
          "expires_at" => 1415304668,
          "expires" => true
        }
        })
      user = User.from_omniauth(auth)
      user.should_not be_nil
    end
  end

end