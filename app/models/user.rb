class User < ApplicationRecord
  has_many :upload_files
  
  validates :email, presence: true
  validates :email, uniqueness: true

  def generate_api_key
    return unless api_token.nil?

    tokens = User.pluck(:api_token)

    token = loop do
      uniq_token = SecureRandom.base58(24)
      break uniq_token unless tokens.include?(uniq_token)
    end

    self.api_token = token
    save!
  end

  def authenticate(unencrypted_password)
    BCrypt::Password.new(password_digest).is_password?(unencrypted_password) && self
  end

  def sign_out!
    update!(api_token: nil)
  end
end
