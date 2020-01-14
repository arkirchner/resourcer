class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project

  before_destroy :check_for_last_admin

  private

  def check_for_last_admin
    return unless owner?

    unless ProjectUser.where.not(user_id: user_id).exists?(project_id: project_id, owner: true)
      raise "The last owner can not be removed!"
    end
  end
end
