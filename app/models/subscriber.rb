class Subscriber < ApplicationRecord
  belongs_to :comic
  belongs_to :user
end
