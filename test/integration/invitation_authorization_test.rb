require "test_helper"

class InvitationAuthorizationTest < ActionDispatch::IntegrationTest
  include IntegrationAuthHelper

  setup do
    @project = FactoryBot.create :project
    @member =
      FactoryBot.create(:project_member, project: @project, owner: false).member
  end

  test "member can not see invitation details" do
    sign_in_as(@member)

    get project_invitation_path(@project, 1)
    assert_response :forbidden
  end

  test "member can not create a project member invitation" do
    sign_in_as(@member)

    post project_invitations_path(@project)
    assert_response :forbidden
  end
end
