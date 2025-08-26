class User < ApplicationRecord
  attr_accessor :current_password
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#?]).{8,70}\z/
  validates :password, presence: true,
                       confirmation: true,
                       format: {
                        with: VALID_PASSWORD_REGEX,
                        message: "must include
                          at least one uppercase letter,
                          one lowercase letter,
                          one digit,
                          and one special character (!@#?),
                          and be at least 8 characters long."
                      },
                      if: -> { password.present? }
end
