require "test_helper"

class ProjectMemberInvitationTest < ActiveSupport::TestCase
  test "project member invitations are unique by invitation" do
    invitation = FactoryBot.create :invitation
    first_project_member =
      FactoryBot.create :project_member, project: invitation.project
    second_project_member =
      FactoryBot.create :project_member, project: invitation.project

    ProjectMemberInvitation.create!(
      project_member: first_project_member, invitation: invitation,
    )

    assert_raise ActiveRecord::RecordNotUnique do
      ProjectMemberInvitation.create!(
        project_member: second_project_member, invitation: invitation,
      )
    end
  end
end
