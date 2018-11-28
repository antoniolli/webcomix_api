FactoryBot.define do
  factory :subscriber do
    is_blocked { false }
    comic_id { nil }
    user_id { nil }
  end
end
