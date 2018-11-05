FactoryBot.define do
  factory :page do
    title { Faker::StarWars.character }
    number { Faker::Number.number(10)}
    is_public { true }
    comic_id { nil }
    trait :with_image do
      image { FilesTestHelper.png }
    end
  end
end
