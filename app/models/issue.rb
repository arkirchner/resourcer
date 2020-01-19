class Issue < ApplicationRecord
  extend ActsAsTree::TreeWalker
  acts_as_tree order: :subject
  belongs_to :project

  has_one :project_member_issue_assignment,
          dependent: :restrict_with_exception, autosave: true
  has_one :project_member, through: :project_member_issue_assignment
  has_one :assignee, through: :project_member, source: :member

  validates :subject, presence: true
  validate :cannot_have_itself_as_parent
  validate :parent_issue_must_have_same_project

  scope :with_project, ->(project) { where(project_id: project) }
  scope :without_issue, ->(issue) { where.not(id: issue) }
  scope :assigned_to,
        lambda { |member|
          joins(:project_member).merge(ProjectMember.where(member: member))
        }

  def project_member_assignment_id=(id)
    if id.blank?
      project_member_issue_assignment&.mark_for_destruction
    elsif project_member_issue_assignment
      project_member_issue_assignment.project_member_id = id
    else
      build_project_member_issue_assignment(project_member_id: id)
    end
  end

  private

  def parent_issue_must_have_same_project
    if parent && project_id != parent.project_id
      errors.add(:project_id, "must be the same as parent issue!")
    end
  end

  def cannot_have_itself_as_parent
    errors.add(:parent_id, "can't not be itself!") if self == parent
  end
end
