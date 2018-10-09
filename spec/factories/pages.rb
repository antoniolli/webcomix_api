FactoryBot.define do
  factory :page do
    title { Faker::StarWars.character }
    number { Faker::Number.number(10)}
    is_public { true }
    comic_id { nil }
  end
end
