FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    sequence(:key) { |n| ("AAA"..."ZZZ").to_a[n] }
  end
end
