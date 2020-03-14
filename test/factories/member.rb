FactoryBot.define do
  factory :member do
    provider { "github" }
    sequence(:provider_id) { |n| format("%<id>010d", id: n) }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
