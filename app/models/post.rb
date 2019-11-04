class Post < ApplicationRecord
  belongs_to :category

  validates :title, :body, presence: true
end
