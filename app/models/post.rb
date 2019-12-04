class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :title, :body, presence: true
end
