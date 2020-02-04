require "test_helper"

class InvetationAuthorizationTest < ActionDispatch::IntegrationTest
  setup do
    @project = FactoryBot.create :project
    @member =
      FactoryBot.create(:project_member, project: @project, owner: false).member
  end

  test "member can not see invitation details" do
    sign_in_as(@member)

    get project_invitation_path(@project, 1)
    assert_response :unauthorized
  end

  test "member can not create a project member invitation" do
    sign_in_as(@member)

    post project_invitations_path(@project)
    assert_response :unauthorized
  end

  def sign_in_as(member)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      member.provider,
      uid: member.provider_id, info: { name: member.name },
    )
    get "/auth/#{member.provider}/callback"
    assert_response :redirect
    OmniAuth.config.mock_auth[member.provider.to_sym] = nil
  end
end
