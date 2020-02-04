class ProjectMemberInvitation < ApplicationRecord
  belongs_to :project_member
  belongs_to :invitation
end
