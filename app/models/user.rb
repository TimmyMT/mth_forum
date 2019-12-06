class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify
end
