class User < ApplicationRecord
  # model association
  has_many :comics, dependent: :destroy
  has_one_attached :avatar

  # validations
  validates_presence_of :name, :email, :password_digest
end
