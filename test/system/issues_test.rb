require "application_system_test_case"

class IssuesTest < ApplicationSystemTestCase
  test "creating a new issue form the top page" do
    FactoryBot.create(:project)

    visit root_url

    click_on "Add issue"

    fill_in "Subject", with: "New issue subject"

    click_on "Create"

    assert_text "New issue created."
  end
end
