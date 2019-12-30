require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  test "creating a projetc through the dashboard" do
    visit root_url

    click_on "Add project"

    fill_in "Name", with: "Resourcer is simple issue tracker."
    fill_in "Key", with: "RSR"

    click_on "Create"

    assert_text "New project was created."
  end
end
