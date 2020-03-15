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

  test "list change history relate to the project" do
    member = FactoryBot.create :member
    project = FactoryBot.create :project, members: [member]
    other_project = FactoryBot.create :project, members: [member]

    related_issue =
      paper_trail_request(
        member: member, request_id: "f3fb4826-843c-4144-bd6a-8e579523b01d",
      ) { FactoryBot.create :issue, project: project }

    History.create_for_request("f3fb4826-843c-4144-bd6a-8e579523b01d")

    unrelated_issue =
      paper_trail_request(
        member: member, request_id: "825e128e-7fb9-4d4a-a447-ce33f8276f63",
      ) { FactoryBot.create :issue, project: other_project }

    History.create_for_request("825e128e-7fb9-4d4a-a447-ce33f8276f63")

    sign_up_with_github(member)

    click_on project.name

    assert_text "#{related_issue.subject}\n#{member.name} create"
    assert_no_text "#{unrelated_issue.subject}\n#{member.name} create"
  end
end
