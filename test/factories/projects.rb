FactoryBot.define do
  factory :project do
    name { Faker::Lorem.sentence }
    sequence(:key) { |n| ("AAA"..."ZZZ").to_a[n] }
  end
end
