class Post < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 3, maximum: 70 }
  validates :description, length: { maximum: 70 }
end
