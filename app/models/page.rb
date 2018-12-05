class Page < ApplicationRecord
  # model association
  belongs_to :comic
  has_many :comments, dependent: :destroy
  has_one_attached :image

  # validations
  validates_presence_of :title, :number
  validates :image, attached: true
end
