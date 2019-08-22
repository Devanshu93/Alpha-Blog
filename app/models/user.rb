class User < ApplicationRecord
  before_create :confirmation_token
  default_scope { order(created_at: :desc)}
  has_many :articles, dependent: :destroy
  before_save { self.email = email.downcase }
  validates :username, presence: true,
                       length: { minimum: 3, maximum: 25 },
                       uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 105 },
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end
  
  private
  def confirmation_token
     if self.confirm_token.blank?
       self.confirm_token = SecureRandom.urlsafe_base64.to_s
     end
  end
end
