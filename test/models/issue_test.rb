require "test_helper"

class IssueTest < ActiveSupport::TestCase
  test "should not save issue without subject" do
    issue = FactoryBot.build :issue, subject: nil
    assert_not issue.save, "Saved the issue without a subject"
  end

  test ".with_porject" do
    project = FactoryBot.create :project
    included_issue = FactoryBot.create :issue, project: project
    excluded_issue = FactoryBot.create :issue

    assert_includes Issue.with_project(project), included_issue
    assert_not_includes Issue.with_project(project), excluded_issue
  end

  test ".without_issue" do
    issue = FactoryBot.create :issue
    excluded_issue = FactoryBot.create :issue

    assert_includes Issue.without_issue(excluded_issue), issue
    assert_not_includes Issue.without_issue(excluded_issue), excluded_issue
  end

  test ".assigned_to, returnes all issues assigned to a member" do
    member = FactoryBot.create :issue

    issue_1 = FactoryBot.create :issue, assignee: member
    issue_2 = FactoryBot.create :issue
    issue_3 = FactoryBot.create :issue, assignee: member

    ProjectMember.create!(project: issue_1.project, member: member)
    ProjectMember.create!(project: issue_3.project, member: member)


    assert_includes Issue.assigned_to(member), issue_1
    assert_not_includes Issue.assigned_to(member), issue_2
    assert_includes Issue.assigned_to(member), issue_3
  end

  test "#assignee, members can be assigend to an issue" do
    project_member = FactoryBot.create :project_member
    project = project_member.project
    member = project_member.member
    issue = FactoryBot.create :issue, project: project

    issue_assignees = IssueAssignee.where(parent: project, assignee: member)

    assert_difference "issue_assignees.count", 1 do
      issue.assignee = member
      issue.save
    end

    assert issue.reload.assignee, member
  end

  test "has parent and children" do
    project = FactoryBot.create :project
    parent = FactoryBot.create :issue, project: project
    children = FactoryBot.create_list :issue, 2, project: project
    issue =
      FactoryBot.create :issue,
                        parent: parent, children: children, project: project

    assert_equal issue.parent, parent
    assert_equal issue.children, children
  end

  test "can not have itself as an parent" do
    issue = FactoryBot.build :issue
    issue.parent = issue

    assert_not issue.save, "Saved issue with itself as parent"
  end

  test "can only have issues from that same project as parent" do
    invalid_parent =
      FactoryBot.create :issue, project: FactoryBot.create(:project)
    issue = FactoryBot.build :issue, parent: invalid_parent

    assert_not issue.save, "Saved parent issue with from diffrent project."
  end
end
