class User < ApplicationRecord
  attr_accessor :current_password
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, presence: true,
                      confirmation: true,
                      length: { minimum: 8, maximum: 70 },
                      password_complexity: true,
                      if: -> { password.present? }
end
