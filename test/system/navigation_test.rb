require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  class ProjectMenuTest < ApplicationSystemTestCase
    test "lists the projects" do
      member = FactoryBot.create(:project_member).member

      FactoryBot.create :project_member, member: member,
        project: FactoryBot.create(:project, name: "First Project.")

      FactoryBot.create :project_member, member: member,
        project: FactoryBot.create(:project, name: "Second Project.")

      sign_up_with_github(member)

      navigation = find "nav"
      content = find "main"

      # Navigate to fist project
      navigation.click_on "Projects"
      navigation.click_on "First Project."
      content.assert_text "First Project."

      # Navigate to second project
      navigation.click_on "Projects"
      navigation.click_on "Second Project."
      content.assert_text "First Project."
    end
  end
end
