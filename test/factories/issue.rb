FactoryBot.define do
  factory :issue do
    project
    creator { create :project_member, project: project }
    subject { Faker::Lorem.sentence }
    description do
      Array.new(rand(2..50)).map { Faker::Markdown.random }.join("\n\n\n")
    end
    due_at { 3.days.from_now }
  end
end
