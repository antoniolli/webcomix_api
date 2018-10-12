class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # model association
  has_many :comics, dependent: :destroy
  has_one_attached :avatar

  # validations
  validates_presence_of :name, :email, :password_digest
end
