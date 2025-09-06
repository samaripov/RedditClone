class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :content, presence: :true, length: { minimum: 5, maximum: 200 }
end
