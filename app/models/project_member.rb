class ProjectMember < ApplicationRecord
  belongs_to :member
  belongs_to :project

  has_many :assigned_issues, class_name: "Issue", foreign_key: :assignee_id
  has_many :created_issues, class_name: "Issue", foreign_key: :creator_id
  has_many :invitations, dependent: :restrict_with_exception

  before_destroy :check_for_last_owner

  private

  def check_for_last_owner
    return unless owner?

    other_prject_members = ProjectMember.where.not(member_id: member_id)

    unless other_prject_members.exists?(project_id: project_id, owner: true)
      raise "The last owner can not be removed!"
    end
  end
end
