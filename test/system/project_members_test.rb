require "application_system_test_case"

class ProjectMembersTest < ApplicationSystemTestCase
  test "the project creator is listed as owner" do
    sign_up_with_github(FactoryBot.create(:member, name: "John Doe"))

    click_on "Add project"

    fill_in "Name", with: "My project!"
    fill_in "Key", with: "MYP"

    click_on "Create"
    click_on "Members"

    within find("#members") do
      assert_text "John Doe"
      assert_text "Role: Owner"
    end
  end
end
