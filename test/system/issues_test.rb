require "application_system_test_case"

class IssuesTest < ApplicationSystemTestCase
  def setup
    super
    @project = FactoryBot.create :project
    @project_member = FactoryBot.create(:project_member, project: @project)
    sign_up_with_github(@project_member.member)
  end

  test "creating a new issue form the top page" do
    click_on "Add issue"
    fill_in "Subject", with: "New issue subject"
    click_on "Create Issue"

    assert_text "New issue subject"
  end

  test "issue markdown description is convererted to HTML" do
    click_on "Add issue"
    fill_in "Subject", with: "New issue subject"
    fill_in "Description", with: "# Heading\n__Advertisement__"
    click_on "Create Issue"

    assert_selector "h1", text: "Heading"
    assert_css "p > strong", text: "Advertisement"
  end

  test "issue markdown can be previewed in form" do
    click_on "Add issue"

    fill_in "Description", with: "# Heading\n__Advertisement__"

    click_on "Preview"

    assert_selector "h1", text: "Heading"
    assert_css "p > strong", text: "Advertisement"
  end

  test "issue with deeply nested children" do
    click_on "Add issue"
    wait_for_turbolinks
    fill_in "Subject", with: "Root issue"
    click_on "Create Issue"
    assert_text "New issue created."

    click_on "Add issue"
    wait_for_turbolinks
    fill_in "Subject", with: "Level 1 child issue"
    select "Root issue", from: "Parent"
    click_on "Create Issue"
    assert_text "New issue created."

    click_on "Add issue"
    wait_for_turbolinks
    fill_in "Subject", with: "Level 2 child issue"
    select "Level 1 child issue", from: "Parent"
    click_on "Create Issue"
    assert_text "New issue created."

    click_on "Issues"
    click_on "Root issue"

    within("#child-issues") do
      assert_text "Level 1 child issue"
      assert_text "Level 2 child issue"
    end
  end

  test "issues can be assigend to a project member" do
    FactoryBot.create(:member, name: "Mike Miller", projects: [Project.last])

    click_on "Add issue"
    fill_in "Subject", with: "New issue for an assigee"
    select "Mike Miller", from: "Assignee"
    click_on "Create Issue"

    assert_text "Assignee Mike Miller"

    FactoryBot.create(:member, name: "John Doe", projects: [Project.last])

    click_on "Edit"

    select "John Doe", from: "Assignee"

    click_on "Update"

    assert_text "Assignee John Doe"

    click_on "Edit"

    select "Not assigned.", from: "Assignee"

    click_on "Update"

    assert_text "Not assigned."
  end

  test "edit issue from show page" do
    issue =
      FactoryBot.create :issue, project: @project, creator: @project_member

    visit project_issue_path(@project, issue)

    click_on "Edit"

    fill_in "Subject", with: "Issue update subject"

    click_on "Update"

    assert_text "Issue was updated."
  end
end
