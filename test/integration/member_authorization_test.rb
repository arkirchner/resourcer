require "test_helper"
require "integration_auth_helper"

class MemberAuthorizationTest < ActionDispatch::IntegrationTest
  include IntegrationAuthHelper

  setup do
    @project = FactoryBot.create :project

    # sign as member that is not a project member
    sign_in_as(FactoryBot.create(:member))
  end

  test "index" do
    get project_members_path(@project)

    assert_response :forbidden
  end
end
