require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  test "creating a projetc through the dashboard" do
    sign_up_with_github

    click_on "Add project"

    fill_in "Name", with: "Resourcer is simple issue tracker."
    fill_in "Key", with: "RSR"

    click_on "Create"

    assert_text "New project was created."
  end

  test "only projects related to the member are displayed" do
    sign_up_with_github
    FactoryBot.create :project, name: "This is not my project!"

    click_on "Add project"

    fill_in "Name", with: "This is a my new project."
    fill_in "Key", with: "MYP"

    click_on "Create"

    click_on "Dashboard"

    assert_text "This is a my new project."
    assert_no_text "This is not my project!"
  end
end
