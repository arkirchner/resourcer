class Issue < ApplicationRecord
  extend ActsAsTree::TreeWalker
  acts_as_tree order: :subject
  belongs_to :project

  # Private associations
  has_one :project_member_issue, dependent: :restrict_with_exception
  has_one :project_member, through: :project_member_issue

  # Public associations
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

  def assignee=(member)
    self.project_member_issue = nil if member.blank?

    build_project_member_issue(
      project_member:
        ProjectMember.find_by!(member: member, project_id: project_id),
    )
  end

  private :project_member_issue,
          :project_member_issue=,
          :project_member,
          :project_member=

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
