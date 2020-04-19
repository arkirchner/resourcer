require "test_helper"
require "integration_auth_helper"

class IssueAuthorizationTest < ActionDispatch::IntegrationTest
  include IntegrationAuthHelper

  setup do
    @project = FactoryBot.create :project

    # sign as member that is not a project member
    sign_in_as(FactoryBot.create(:member))
  end

  test "new" do
    get new_project_issue_path(@project)

    assert_response :forbidden
  end

  test "create" do
    post project_issues_path(@project)

    assert_response :forbidden
  end

  test "show" do
    issue = FactoryBot.create :issue, project: @project
    get project_issue_path(@project, issue)

    assert_response :forbidden
  end

  test "index" do
    get project_issues_path(@project)

    assert_response :forbidden
  end

  test "edit" do
    issue = FactoryBot.create :issue, project: @project
    get edit_project_issue_path(@project, issue)

    assert_response :forbidden
  end

  test "update" do
    issue = FactoryBot.create :issue, project: @project
    patch project_issue_path(@project, issue)

    assert_response :forbidden
  end
end
