FactoryBot.define do
  factory :project do
    name { Faker::Lorem.words }
    sequence(:key) { |n| ("AAA"..."ZZZ").to_a[n] }
  end
end
