class User < ApplicationRecord
  has_secure_password
  attr_accessor :remember_token

  # Begin class method
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ?
              BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password(string, cost)
    end

    def new_token
      SecureRandom.urlsafe.base64
    end
  end
  # End class method
  private

end
