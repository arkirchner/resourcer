FactoryBot.define do
  factory :member do
    provider { "github" }
    sequence(:provider_id) { |n| format("%<id>010d", id: n) }
    sequence(:name) { |n| "Github User #{n}" }
    sequence(:email) { |n| "member_#{n}@example.com" }
  end
end
