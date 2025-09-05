class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :liked_posts
  has_many :likes_from_users, through: :liked_posts, source: :user
  has_one_attached :post_image
  validates :title, presence: true, length: { minimum: 3, maximum: 70 }
  validates :description, length: { maximum: 400 }

  def user_likes_count
    liked_posts.count
  end
end
