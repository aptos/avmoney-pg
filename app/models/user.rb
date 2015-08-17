class User < ActiveRecord::Base
  before_create { generate_auth_token }

  def self.from_omniauth(auth)
    where(email: auth['info']['email']).first_or_create do |user|
      user.email = auth['info']['email']
      user.name = auth['info']['name']
      user.save
    end
  end

  def generate_auth_token
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64(12,false)
    end while User.where(auth_token: self[:auth_token]).first
  end

end
