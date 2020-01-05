require 'test_helper'

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
    excluded_issue  = FactoryBot.create :issue

    assert_includes Issue.without_issue(excluded_issue), issue
    assert_not_includes Issue.without_issue(excluded_issue), excluded_issue
  end

  test "has parent and children" do
    parent = FactoryBot.create :issue
    children = FactoryBot.create_list :issue, 2
    issue = FactoryBot.create :issue, parent: parent, children: children

    assert_equal issue.parent, parent
    assert_equal issue.children, children
  end

  test "can to have itself as an parent" do
    issue = FactoryBot.build :issue
    issue.parent = issue

    assert_not issue.save, "Saved issue with itself as parent"
  end
end
