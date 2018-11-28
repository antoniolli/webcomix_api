class Comic < ApplicationRecord
  # model association
  belongs_to :user
  has_many :pages, dependent: :destroy
  has_many :subscribers, dependent: :destroy
  has_one_attached :cover

  # validations
  validates_presence_of :name, :description, :is_public, :is_comments_active
end
