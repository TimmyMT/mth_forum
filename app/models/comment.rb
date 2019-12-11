class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :post_images, dependent: :destroy, as: :post_imageble, inverse_of: :post_imageble
  accepts_nested_attributes_for :post_images

  validates :body, presence: true
end
