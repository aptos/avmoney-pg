class User < ActiveRecord::Base
  before_create { generate_auth_token }

  # property :email, type: String
  # property :name, String
  # property :auth_token, String
  # unique_id :email
  # timestamps!

  # design do
  #   view :by_email
  #   view :by_auth_token
  # end


  def self.from_omniauth(auth)
    User.find(auth['info']['email']) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.email = auth['info']['email']
      user.name = auth['info']['name']
    end
  end

  def generate_auth_token
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64(12,false)
    end while User.by_auth_token.key(self[:auth_token]).first
  end

end
