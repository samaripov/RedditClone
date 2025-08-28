class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :post_image
  validates :title, presence: true, length: { minimum: 3, maximum: 70 }
  validates :description, length: { minimum: 3, maximum: 400 }
end
