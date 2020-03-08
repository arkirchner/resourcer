class History::ProjectMemberIssueAssignment < ApplicationRecord
  belongs_to :history
  belongs_to :from_project_member, optional: true, class_name: "ProjectMember"
  belongs_to :to_project_member, optional: true, class_name: "ProjectMember"

  has_one :from_member, through: :from_project_member, source: :member
  has_one :to_member, through: :to_project_member, source: :member

  def changes=(changes)
    self.from_project_member_id, self.to_project_member_id =
      changes[:project_member_id]
  end
end
