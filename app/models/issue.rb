class Issue < ApplicationRecord
  extend ActsAsTree::TreeWalker
  acts_as_tree order: :subject
  belongs_to :project
  validates :subject, presence: true
  validate :cannot_itself_as_parent

  scope :with_project, ->(project) { where(project_id: project) }
  scope :without_issue, ->(issue) { where.not(id: issue) }

  private

  def cannot_itself_as_parent
    if self == parent
      errors.add(:parent_id, "can't not be itself!")
    end
  end
end
