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

  test "edit issue from show page" do
    issue = FactoryBot.create :issue

    visit issue_path(issue)

    click_on "Edit"

    fill_in "Subject", with: "Issue update subject"

    click_on "Update"

    assert_text "Issue was updated."
  end

  def create_issue(subject:, parent: nil, description: nil)
    click_on "Add issue"
    fill_in "Subject", with: subject
    fill_in "Description", with: description if description
    if parent
      label = find("label", text: "Parent")
      label.click

      within label.find(:xpath, "..").find(".choices__item", text: parent).click
    end

    click_on "Create"

    assert_text "New issue created."
  end
end
