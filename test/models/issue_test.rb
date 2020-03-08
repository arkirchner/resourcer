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

  test ".parentable_issues" do
    issue = FactoryBot.create :issue
    assert_empty Issue.parentable_issues(issue), "Can not be parent if itself."

    grandparent = FactoryBot.create(:issue, project: issue.project)
    parent =
      FactoryBot.create(:issue, project: issue.project, parent: grandparent)
    issue.update!(parent: parent)
    assert_empty Issue.parentable_issues(issue),
                 "Ancestors can not be a ancestor of them self."

    issue_of_other_project = FactoryBot.create :issue
    assert_empty Issue.parentable_issues(issue),
                 "Issues of other projects can not be parents."

    parentable_issue = FactoryBot.create :issue, project: issue.project
    assert_equal Issue.parentable_issues(issue), [parentable_issue]
  end

  test ".assigned_to, returnes all issues assigned to a member" do
    project_member = FactoryBot.create :project_member
    project = project_member.project
    member = project_member.member

    issue_one =
      FactoryBot.create :issue,
                        project: project,
                        project_member_assignment_id: project_member.id
    issue_two = FactoryBot.create :issue, project: project
    issue_three =
      FactoryBot.create :issue,
                        project: project,
                        project_member_assignment_id: project_member.id

    assert_includes Issue.assigned_to(member), issue_one
    assert_not_includes Issue.assigned_to(member), issue_two
    assert_includes Issue.assigned_to(member), issue_three
  end

  test "#project_member_assignment_id=, members can be assigend to an issue" do
    project = FactoryBot.create :project
    project_member_one = FactoryBot.create :project_member, project: project
    project_member_two = FactoryBot.create :project_member, project: project

    params =
      FactoryBot.attributes_for :issue,
                                project_id: project.id,
                                project_member_assignment_id:
                                  project_member_one.id

    issue = Issue.create(params)

    assert_equal project_member_one.member, issue.assignee

    issue.update(project_member_assignment_id: project_member_two.id)

    assert_equal project_member_two.member, issue.reload.assignee

    issue.update(project_member_assignment_id: "")

    assert_nil issue.reload.assignee
  end

  test "has parent and children" do
    project = FactoryBot.create :project
    parent = FactoryBot.create :issue, project: project
    issue = FactoryBot.create :issue, parent: parent, project: project
    children = FactoryBot.create_list :issue, 2, project: project, parent: issue

    assert_equal issue.parent, parent
    assert_equal issue.children, children
  end

  test "can not have itself as an parent" do
    issue = FactoryBot.create :issue
    issue.parent = issue

    assert_not issue.save, "Saved issue with itself as parent"
  end

  test "can not have a child as an parent" do
    project = FactoryBot.create :project
    issue = FactoryBot.create :issue, project: project
    child_issue = FactoryBot.create :issue, project: project, parent: issue

    assert_not issue.update(parent: child_issue),
               "Saved issue with child as parent"
  end

  test "can only have issues from that same project as parent" do
    invalid_parent =
      FactoryBot.create :issue, project: FactoryBot.create(:project)
    issue = FactoryBot.build :issue, parent: invalid_parent

    assert_not issue.save, "Saved parent issue with from diffrent project."
  end
end
