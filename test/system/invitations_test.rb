require "application_system_test_case"

class InvitationsTest < ApplicationSystemTestCase
  setup do
    @member = FactoryBot.create(:member, name: "John Doe")
    @project = FactoryBot.create(:project, key: "MYP", name: "My Project")
    ProjectMember.create(member: @member, project: @project, owner: true)
    sign_up_with_github(@member)

    click_on "MYP"
    click_on "Members"

    click_on "Invite new member"

    fill_in "Note", with: "Invitation for Ace Ventura"
    click_on "Create Invitation"
    wait_for_turbolinks

    @invitation_url = find("#invitation-url").value

    click_on "Close"
    assert_selector "a", text: "Invitation for Ace Ventura"

    click_on "John Doe"
    click_on "Sign Out"
  end

  test "a member can join the project with an inviation url" do
    mock_auth_for_invited_user

    visit @invitation_url

    click_button "Continue with Github"

    assert_text "You have joined \"MYP: My Project\""

    click_on "MYP"
    click_on "Members"
    wait_for_turbolinks

    within find("#members") do
      assert_text "Ace Ventura"
      assert_text "Role: Member"
    end
  end

  test "an expired invitation_url will show error notice" do
    mock_auth_for_invited_user

    freeze_time do
      travel 7.days + 1.second

      visit @invitation_url

      click_button "Continue with Github"

      assert_text "Your project inviation is expired. Please contact the " \
                    "project owner to recieve a new inviation url."
    end
  end

  test "a member can not see inviation created by a project owner" do
    FactoryBot.create :invitation,
                      project: @project,
                      note: "Another project member invitation"

    mock_auth_for_invited_user

    visit @invitation_url

    click_button "Continue with Github"

    assert_text "You have joined \"MYP: My Project\""

    click_on "MYP"
    click_on "Members"

    wait_for_turbolinks

    assert_no_selector "a", text: "Another project member invitation"
  end

  def mock_auth_for_invited_user
    OmniAuth.config.add_mock(
      "github",
      uid: "654321", info: { name: "Ace Ventura" },
    )
  end
end
