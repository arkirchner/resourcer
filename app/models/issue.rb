class Issue < ApplicationRecord
  acts_as_tree order: :subject
  belongs_to :project
  validates :subject, presence: true

  scope :with_project, ->(project) { where(project_id: project) }
end
