class Issue < ApplicationRecord
  has_ancestry
  has_paper_trail
  belongs_to :project

  has_many :histories, dependent: :restrict_with_exception

  has_many :parentable_issues, -> { all }, through: :project, source: :issues
  has_one :project_member_issue_assignment,
          dependent: :restrict_with_exception, autosave: true
  has_one :project_member, through: :project_member_issue_assignment
  has_one :assignee, through: :project_member, source: :member

  validates :subject, presence: true
  validate :cannot_have_itself_as_parent
  validate :parent_issue_must_have_same_project

  scope :with_project, ->(project) { where(project_id: project) }
  scope :parentable_issues,
        lambda { |issue|
          with_project(issue.project_id).where.not(id: issue).then do |relation|
            return relation unless issue.parent_id

            relation.where.not(id: self.ancestors_of(issue.parent_id))
          end
        }

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

  def project_member_assignment_id
    project_member_issue_assignment&.project_member_id
  end

  private

  def parent_issue_must_have_same_project
    if parent && project_id != parent.project_id
      errors.add(:project_id, "must be the same as parent issue!")
    end
  end

  def cannot_have_itself_as_parent
    if parent_is_a_child_or_itself?
      errors.add(:parent_id, "can't not be itself or a child of this Issue!")
    end
  end

  def parent_is_a_child_or_itself?
    return true if self == parent

    persisted? && parent && ancestor_of?(parent)
  end
end
