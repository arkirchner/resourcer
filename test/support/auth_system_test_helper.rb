module AuthSystemTestHelper
  def mock_omin_auth_providers
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :github,
      uid: "12345", info: { name: "Github User", email: "test@hoge.com" },
    )
  end

  def clear_omni_auth_mock
    OmniAuth.config.mock_auth[:github] = nil
  end

  def sign_up_with_github
    visit root_path
    click_button "Continue with Github"
  end
end
