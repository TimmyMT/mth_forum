class PostImage < ApplicationRecord
  belongs_to :post

  has_one_attached :image
  validates :image, file_size: { less_than_or_equal_to: 10.megabytes },
    file_content_type: { allow: ['image/jpeg', 'image/jpg', 'image/png'] }
end
