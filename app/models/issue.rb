class Issue < ApplicationRecord
  has_ancestry
  has_paper_trail
  belongs_to :project
  belongs_to :creator, class_name: "ProjectMember", optional: true
  belongs_to :assignee, class_name: "ProjectMember", optional: true

  has_many :histories, dependent: :restrict_with_exception

  validates :creator_id, presence: true, if: :new_record?
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
          joins(:assignee).merge(ProjectMember.where(member: member))
        }

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
