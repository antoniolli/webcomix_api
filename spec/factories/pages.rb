FactoryBot.define do
  factory :page do
    title { Faker::StarWars.character }
    number { Faker::Number.number(10)}
    is_public { Faker::Boolean.boolean }
    comic_id nil
  end
end
