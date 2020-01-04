require "application_system_test_case"

class IssuesTest < ApplicationSystemTestCase
  test "creating a new issue form the top page" do
    FactoryBot.create(:project)

    visit root_url

    click_on "Add issue"

    fill_in "Subject", with: "New issue subject"

    click_on "Create"

    assert_text "New issue created."
    assert_text "New issue subject"
  end

  test "issue page includes children" do
    second_child_issue = FactoryBot.create :issue, subject: "Second child Issue"
    child_issue = FactoryBot.create :issue, children: [second_child_issue], subject: "First child Issue"
    issue = FactoryBot.create :issue, children: [child_issue]

    visit issue_path(issue)

    assert_text "Second child Issue"
    assert_text "First child Issue"
  end
end
