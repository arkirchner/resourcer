require "application_system_test_case"

class DashboardTest < ApplicationSystemTestCase
  class MtIssuesTest < ApplicationSystemTestCase
    test "lists affigned issues by default" do
      travel_to Time.current.middle_of_day.to_datetime do
        project_member = FactoryBot.create(:project_member)

        FactoryBot.create :issue,
                          subject: "A issue due today!",
                          project: project_member.project,
                          assignee: project_member,
                          due_at: Date.today
        FactoryBot.create :issue,
                          subject: "This issue is due tomorrow.",
                          project: project_member.project,
                          assignee: project_member,
                          due_at: Date.tomorrow

        FactoryBot.create :issue,
                          subject: "This issue is due in 4 days.",
                          project: project_member.project,
                          assignee: project_member,
                          due_at: 4.days.from_now

        FactoryBot.create :issue,
                          subject: "This issue is overdue.",
                          project: project_member.project,
                          assignee: project_member,
                          due_at: 1.day.ago

        FactoryBot.create :issue,
                          project: project_member.project,
                          subject: "This issue is not assigned to the member."
        FactoryBot.create :issue, subject: "This is a unrelated issue."

        sign_up_with_github(project_member.member)

        assert_text "A issue due today!"
        assert_text "This issue is due tomorrow."
        assert_text "This issue is due in 4 days."
        assert_text "This issue is overdue."
        assert_no_text "This issue is not assigned to the member."
        assert_no_text "This is a unrelated issue."

        click_on "4 Days"
        wait_for_turbolinks
        assert_text "A issue due today!"
        assert_text "This issue is due tomorrow."
        assert_text "This issue is due in 4 days."
        assert_no_text "This issue is overdue."
        assert_no_text "This issue is not assigned to the member."
        assert_no_text "This is a unrelated issue."

        click_on "Due Today"
        wait_for_turbolinks
        assert_text "A issue due today!"
        assert_no_text "This issue is due tomorrow."
        assert_no_text "This issue is due in 4 days."
        assert_no_text "This issue is overdue."
        assert_no_text "This issue is not assigned to the member."
        assert_no_text "This is a unrelated issue."

        click_on "Overdue"
        wait_for_turbolinks
        assert_no_text "A issue due today!"
        assert_no_text "This issue is due tomorrow."
        assert_no_text "This issue is due in 4 days."
        assert_text "This issue is overdue."
        assert_no_text "This issue is not assigned to the member."
        assert_no_text "This is a unrelated issue."
      end
    end

    test "a member can check issue he created" do
      project_member = FactoryBot.create(:project_member)
      project = project_member.project
      member = project_member.member

      FactoryBot.create :issue,
                        project: project,
                        creator: project_member,
                        subject: "My first Issue."
      FactoryBot.create :issue,
                        project: project,
                        creator: project_member,
                        subject: "My second Issue."
      FactoryBot.create :issue,
                        project: project,
                        assignee: project_member,
                        subject: "Issue assigned to me."
      FactoryBot.create :issue,
                        project: project, subject: "Issue not related to me."

      sign_up_with_github(project_member.member)
      click_on "Created by me"
      wait_for_turbolinks

      assert_text "My first Issue."
      assert_text "My second Issue."
      assert_no_text "Issue assigned to me."
      assert_no_text "Issue not related to me."
    end
  end

  test "projects related to the member are displayed" do
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
                          project: project_member.project,
                          creator: project_member
      end

    History.create_for_request("825e128e-7fb9-4d4a-a447-ce33f8276f63")

    related_issue =
      paper_trail_request(
        member: other_project_member.member,
        request_id: "f3fb4826-843c-4144-bd6a-8e579523b01d",
      ) do
        FactoryBot.create :issue,
                          project: project_member.project,
                          creator: other_project_member,
                          assignee: project_member
      end

    History.create_for_request("f3fb4826-843c-4144-bd6a-8e579523b01d")

    unrelated_issue =
      paper_trail_request(
        member: unrelated_project_member.member,
        request_id: "c2a5bf0e-9a71-4095-b217-b64317e10f33",
      ) do
        FactoryBot.create :issue,
                          project: unrelated_project_member.project,
                          creator: unrelated_project_member
      end

    History.create_for_request("c2a5bf0e-9a71-4095-b217-b64317e10f33")

    sign_up_with_github(project_member.member)

    assert_text "#{own_issue.subject}\n#{project_member.member.name} create"
    assert_text "#{related_issue.subject}\n#{
                  other_project_member.member.name
                } create"
    assert_no_text "#{unrelated_issue.subject}\n#{
                     unrelated_project_member.member.name
                   } create"
  end
end
