require "application_system_test_case"

class DashboardTest < ApplicationSystemTestCase
  test "lists the members projects" do
    member = FactoryBot.create :member
    other_member = FactoryBot.create :member
    first_project = FactoryBot.create :project, members: [member]
    second_project = FactoryBot.create :project, members: [member, other_member]
    unrelated_project = FactoryBot.create :project, members: [other_member]

    sign_up_with_github(member)

    assert_text first_project.name
    assert_text second_project.name
    assert_no_text unrelated_project.name
  end

  test "lists assigned issues" do
    project_member = FactoryBot.create(:project_member)

    first_assigned_issue =
      FactoryBot.create :issue,
                        project: project_member.project,
                        project_member: project_member
    secound_assigned_issue =
      FactoryBot.create :issue,
                        project: project_member.project,
                        project_member: project_member

    unassigned_issue = FactoryBot.create :issue, project: project_member.project
    unrelated_issue = FactoryBot.create :issue

    sign_up_with_github(project_member.member)

    assert_text first_assigned_issue.subject
    assert_text secound_assigned_issue.subject
    assert_no_text unassigned_issue.subject
    assert_no_text unrelated_issue.subject
  end

  test "list change history relate to the user" do
    project_member = FactoryBot.create :project_member
    unrelated_project_member = FactoryBot.create :project_member
    other_project_member =
      FactoryBot.create :project_member,
                        member: unrelated_project_member.member,
                        project: project_member.project

    own_issue =
      paper_trail_request(
        member: project_member.member,
        request_id: "825e128e-7fb9-4d4a-a447-ce33f8276f63",
      ) do
        FactoryBot.create :issue,
                          project: project_member.project
      end

    History.create_for_request("825e128e-7fb9-4d4a-a447-ce33f8276f63")

    related_issue =
      paper_trail_request(
        member: other_project_member.member,
        request_id: "f3fb4826-843c-4144-bd6a-8e579523b01d",
      ) do
        FactoryBot.create :issue,
                          project: project_member.project,
                          project_member: other_project_member,
                          project_member_assignment_id: project_member.id
      end

    History.create_for_request("f3fb4826-843c-4144-bd6a-8e579523b01d")

    unrelated_issue =
      paper_trail_request(
        member: unrelated_project_member.member,
        request_id: "c2a5bf0e-9a71-4095-b217-b64317e10f33",
      ) do
        FactoryBot.create :issue,
                          project: unrelated_project_member.project,
                          project_member: unrelated_project_member
      end

    History.create_for_request("c2a5bf0e-9a71-4095-b217-b64317e10f33")


    sign_up_with_github(project_member.member)

    assert_text "#{own_issue.subject}\n#{project_member.member.name} create"
    assert_text "#{related_issue.subject}\n#{other_project_member.member.name} create"
    assert_no_text "#{unrelated_issue.subject}\n#{unrelated_project_member.member.name} create"
  end
end
