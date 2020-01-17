require "application_system_test_case"

class IssuesTest < ApplicationSystemTestCase
  def setup
    super
    sign_up_with_github(FactoryBot.create(:project_member).member)
  end

  test "creating a new issue form the top page" do
    create_issue subject: "New issue subject"

    assert_text "New issue subject"
  end

  test "issue markdown description is convererted to HTML" do
    create_issue subject: "New issue subject",
                 description: "# Heading\n__Advertisement__"

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
    create_issue subject: "Root issue"
    create_issue subject: "Level 1 child issue", parent: "Root issue"
    create_issue subject: "Level 2 child issue", parent: "Level 1 child issue"

    click_on "Issues"
    click_on "Root issue"

    within("#child-issues") do
      assert_text "Level 1 child issue"
      assert_text "Level 2 child issue"
    end
  end

  test "issues can be assigend to a project member" do
    assignee =
      FactoryBot.create(:member, name: "Mike Miller", projects: [Project.last])

    create_issue subject: "Root issue", assignee: "Mike Miller"

    assert_text "Assignee Mike Miller"

    assignee =
      FactoryBot.create(:member, name: "John Doe", projects: [Project.last])

    click_on "Edit"

    select_option("Assignee", "John Doe")

    click_on "Update"

    assert_text "Assignee John Doe"

    click_on "Edit"

    find("label", text: "Assignee").click
    first(".choices__placeholder", text: "Not assigned.").click

    click_on "Update"

    assert_text "Not assigned."
  end

  test "edit issue from show page" do
    issue = FactoryBot.create :issue

    visit issue_path(issue)

    click_on "Edit"

    fill_in "Subject", with: "Issue update subject"

    click_on "Update"

    assert_text "Issue was updated."
  end

  def create_issue(subject:, parent: nil, description: nil, assignee: nil)
    click_on "Add issue"
    fill_in "Subject", with: subject
    fill_in "Description", with: description if description

    select_option("Parent", parent) if parent
    select_option("Assignee", assignee) if assignee

    click_on "Create"

    assert_text "New issue created."
  end

  def select_option(name, value)
    label = find("label", text: name)
    label.click

    within label.find(:xpath, "..").find(".choices__item", text: value).click
  end
end
