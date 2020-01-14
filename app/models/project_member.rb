class ProjectMember < ApplicationRecord
  belongs_to :member
  belongs_to :project

  before_destroy :check_for_last_owner

  private

  def check_for_last_owner
    return unless owner?

    unless ProjectMember.where.not(member_id: member_id).exists?(project_id: project_id, owner: true)
      raise "The last owner can not be removed!"
    end
  end
end
