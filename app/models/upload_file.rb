class UploadFile < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  before_create :generate_shared_url

  private

  def generate_shared_url
    self.shared_url = SecureRandom.hex(10)
  end
end
