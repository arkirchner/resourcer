require "test_helper"

class HistoryTest < ActiveSupport::TestCase
  class CreateForRequest < ActiveSupport::TestCase
    def setup
      @request_id = SecureRandom.uuid
      project_member = FactoryBot.create :project_member
      @member = project_member.member
      @project = project_member.project
      @assignee = FactoryBot.create(:project_member, project: @project)
    end

    test "issue created with member assignment" do
      paper_trail_request(member: @member, request_id: @request_id) do
        issue =
          FactoryBot.create :issue,
                            project: @project,
                            project_member_assignment_id: @assignee.id

        assert_difference [
                            "History.where(issue_id: issue).count",
                            "History::Issue.count",
                            "History::ProjectMemberIssueAssignment.count",
                          ],
                          1 do
          History.create_for_request(@request_id)
        end
      end
    end

    test "issue update creates a history" do
      issue = PaperTrail.request(enabled: false) { FactoryBot.create :issue }

      paper_trail_request(member: @member, request_id: @request_id) do
        issue.update(subject: "New subject for issue!")

        assert_difference -> { History.where(issue_id: issue).count } => 1,
                          -> { History::Issue.count } => 1,
                          -> { History::ProjectMemberIssueAssignment.count } =>
                            0 do
          History.create_for_request(@request_id)
        end
      end
    end

    test "records history for issue association update" do
      issue = PaperTrail.request(enabled: false) do
        member_id = FactoryBot.create(:project_member, project: @project).id
        FactoryBot.create :issue, project: @project, project_member_assignment_id: member_id
      end

      paper_trail_request(member: @member, request_id: @request_id) do
        issue.update(project_member_assignment_id: @assignee.id)

        assert_difference -> { History.where(issue_id: issue).count } => 1,
                          -> { History::Issue.count } => 0,
                          -> { History::ProjectMemberIssueAssignment.count } =>
                            1 do
          History.create_for_request(@request_id)
        end
      end
    end

    test "records history for issue association destruction" do
      issue = PaperTrail.request(enabled: false) do
        FactoryBot.create :issue, project: @project, project_member_assignment_id: @assignee.id
      end

      paper_trail_request(member: @member, request_id: @request_id) do
        issue.update(project_member_assignment_id: nil)

        assert_difference -> { History.where(issue_id: issue).count } => 1,
                          -> { History::Issue.count } => 0,
                          -> { History::ProjectMemberIssueAssignment.count } =>
                            1 do
          History.create_for_request(@request_id)
        end
      end
    end
  end
end
