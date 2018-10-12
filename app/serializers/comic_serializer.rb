class ComicSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :name, :description, :is_public, :is_comments_active, :user_id, :created_at, :updated_at
  # model association
  has_many :pages
end
