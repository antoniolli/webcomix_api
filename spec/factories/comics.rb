FactoryBot.define do
  factory :comic do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    is_public { Faker::Boolean.boolean }
    is_comments_active { Faker::Boolean.boolean }
    user_id nil
  end
end
