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
end
