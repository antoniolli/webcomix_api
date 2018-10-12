# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do
  comic = Comic.create(name: Faker::StarTrek.character, description: Faker::Lorem.paragraph, is_public: true, is_comments_active: true,user_id: User.first.id)
  10.times do |i|
    comic.pages.create(title: Faker::StarTrek.specie, number: i, is_public: true)
  end
end
