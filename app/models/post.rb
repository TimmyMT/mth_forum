class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :post_images, dependent: :destroy
  accepts_nested_attributes_for :post_images

  validates :title, :body, presence: true
end
