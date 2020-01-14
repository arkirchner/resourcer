require "application_system_test_case"

class IssuesTest < ApplicationSystemTestCase
  test "the project creator is listed as owner" do
    user = FactoryBot.create :user, name: "John Doe"

    sign_up_with_github(user)

    click_on "Add project"

    fill_in "Name", with: "My project!"
    fill_in "Key", with: "MYP"

    click_on "Create"
    click_on "Members"

    within find("#members") do
      assert_text "John Doe"
      assert_text "Role: Admin"
    end
  end
end
