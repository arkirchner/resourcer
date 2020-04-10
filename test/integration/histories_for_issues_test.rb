require "test_helper"
require "integration_auth_helper"

class HistoriesForIssuesTest < ActionDispatch::IntegrationTest
  include IntegrationAuthHelper

  setup do
    @project = FactoryBot.create :project
    @member =
      FactoryBot.create(:project_member, project: @project, owner: false).member
  end

  test "#create, saves a version and starts the create history backround job" do
    sign_in_as(@member)

    request_id = "fd98e533-8362-4299-bc24-da1bf6c42b52"

    SecureRandom.stub :uuid, request_id do
      assert_changes "PaperTrail::Version.where(request_id: request_id).count", from: 0, to: 1 do
        post project_issues_path(@project),
             params: {
               issue: { subject: "A new issue" },
             }

        assert_enqueued_with(job: CreateHistoryJob, args: [request_id])
      end
    end
  end

  test "#update, saves a version and starts the create history backround job" do
    sign_in_as(@member)

    issue = FactoryBot.create :issue, project: @project

    request_id = "fd98e533-8362-4299-bc24-da1bf6c42b52"

    SecureRandom.stub :uuid, request_id do
      assert_changes "PaperTrail::Version.where(request_id: request_id).count", from: 0, to: 1 do
        patch project_issue_path(issue.project, issue),
              params: {
                issue: { subject: "A new issue" },
              }

        assert_enqueued_with(job: CreateHistoryJob, args: [request_id])
      end
    end
  end
end
