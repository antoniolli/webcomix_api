class Page < ApplicationRecord
  # model association
  belongs_to :comic
  has_many :comments, dependent: :destroy
  has_one_attached :image

  # validations
  validates_presence_of :title, :number, :is_public
  validates :image, attached: true
end
