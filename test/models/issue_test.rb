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
    sleep 1
    assert_empty Issue.parentable_issues(issue), "Can not be parent if itself."

    issue_of_other_project = FactoryBot.create :issue
    sleep 1
    assert_empty Issue.parentable_issues(issue),
                 "Issues of other projects can not be parents."

    grandparent = FactoryBot.create(:issue, project: issue.project)
    parent =
      FactoryBot.create(:issue, project: issue.project, parent: grandparent)
    issue.update!(parent: parent)
    sleep 1
    assert_equal Issue.parentable_issues(issue), [parent]
                 "Grand ancestors can not be a ancestor of them self."

    parentable_issue = FactoryBot.create :issue, project: issue.project
    sleep 1
    assert_equal Issue.parentable_issues(issue), [parent, parentable_issue]
  end

  test ".assigned_to, returnes all issues assigned to a member" do
    project_member = FactoryBot.create :project_member
    project = project_member.project
    member = project_member.member

    issue_one =
      FactoryBot.create :issue,
                        project: project,
                        assignee: project_member
    issue_two = FactoryBot.create :issue, project: project
    issue_three =
      FactoryBot.create :issue,
                        project: project,
                        assignee: project_member

    assert_includes Issue.assigned_to(member), issue_one
    assert_not_includes Issue.assigned_to(member), issue_two
    assert_includes Issue.assigned_to(member), issue_three
  end

  test "#sequential_id, created scoped by project" do
    project_a = FactoryBot.create :project
    project_b = FactoryBot.create :project

    project_a_issue_one = FactoryBot.create :issue, project: project_a
    project_a_issue_two = FactoryBot.create :issue, project: project_a
    project_b_issue_one = FactoryBot.create :issue, project: project_b
    project_b_issue_two = FactoryBot.create :issue, project: project_b

    assert_equal project_a_issue_one.sequential_id, 1
    assert_equal project_a_issue_two.sequential_id, 2
    assert_equal project_b_issue_one.sequential_id, 1
    assert_equal project_b_issue_two.sequential_id, 2
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
