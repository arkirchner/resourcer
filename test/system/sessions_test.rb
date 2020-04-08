require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "visitor can sign up with Github" do
    member = FactoryBot.create(:member, name: "John Doe")
    sign_up_with_github(member)

    assert_text "Hello John Doe"
    assert_text "My issues"
  end

  test "visitor can sign up with Google" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :google_oauth2,
      uid: "123456", info: { name: "Indiana Jones" },
    )

    visit root_path
    click_button "Continue with Google"

    assert_text "Hello Indiana Jones"
    assert_text "My issues"
  end

  test "visitor can see an error if the authentication fails" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    # Do not raise an error. Redirect like in production
    OmniAuth.config.on_failure = Proc.new { |env|
        OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
    visit root_path

    click_button "Continue with Github"

    assert_text "invalid_credentials"
  end

  test "when the member logs out he will be redirected to the top page" do
    member = FactoryBot.create(:member, name: "John Doe")
    sign_up_with_github(member)
    click_on "John Doe"
    click_on "Sign Out"

    assert_text "Goodbye John Doe"
    assert_text "Resourcer the project planner."
  end
end
