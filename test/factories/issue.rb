FactoryBot.define do
  factory :issue do
    sequence(:subject) { |n| "Issue #{n}" }
    due_at { 3.days.from_now }
  end
end
