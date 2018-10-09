FactoryBot.define do
  factory :comic do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    is_public { true }
    is_comments_active { true }
    user_id { nil }
  end
end
