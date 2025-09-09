class User < ApplicationRecord
  attr_accessor :current_password
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ],
    preprocessed: true
  end
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, presence: true,
                      confirmation: true,
                      length: { minimum: 8, maximum: 70 },
                      password_complexity: true,
                      if: -> { password.present? }
  has_many :posts, dependent: :destroy
  has_many :liked_posts, dependent: :destroy
  has_many :favourite_posts, through: :liked_posts, source: :post, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :followings, foreign_key: :follower_id, class_name: "Following", dependent: :destroy
  has_many :followed_users, through: :followings, source: :followed, dependent: :destroy

  has_many :reverse_followings, foreign_key: :followed_id, class_name: "Following", dependent: :destroy
  has_many :followers, through: :reverse_followings, source: :follower, dependent: :destroy
end
