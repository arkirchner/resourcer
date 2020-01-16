require "test_helper"

class ProjectMemberIssueTest < ActiveSupport::TestCase
  test "issues can only once by assigend to a member" do
    project_member = FactoryBot.create :project_member
    issue = FactoryBot.create :issue, project: project_member.project

    ProjectMemberIssue.create(project_member: project_member, issue: issue)

    assert_raise ActiveRecord::RecordNotUnique do
      ProjectMemberIssue.create(project_member: project_member, issue: issue)
    end
  end

  test "issues can only be assigned to one member" do
    project_member = FactoryBot.create :project_member
    issue = FactoryBot.create :issue, project: project_member.project

    other_project_member = FactoryBot.create :project_member

    ProjectMemberIssue.create(project_member: project_member, issue: issue)

    assert_raise ActiveRecord::RecordNotUnique do
      ProjectMemberIssue.create(project_member: other_project_member, issue: issue)
    end
  end
end
