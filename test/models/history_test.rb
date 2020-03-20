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

    test "issue update creates a history" do
      issue = PaperTrail.request(enabled: false) { FactoryBot.create :issue }

      paper_trail_request(member: @member, request_id: @request_id) do
        issue.update(subject: "New subject for issue!")

        assert_difference -> { History.where(issue_id: issue).count } => 1,
                          -> { History::Issue.count } => 1 do
          History.create_for_request(@request_id)
        end
      end
    end
  end
end
