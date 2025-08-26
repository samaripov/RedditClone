class User < ApplicationRecord
  attr_accessor :current_password
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :password, presence: true, on: :create
end
