FactoryBot.define do
  factory :invitation do
    project_member
    note { Faker::Lorem.sentence }
  end
end
