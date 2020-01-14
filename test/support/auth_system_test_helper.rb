module AuthSystemTestHelper
  def mock_omin_auth_providers(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      user.provider,
      uid: user.provider_id, info: { name: user.name, email: user.email },
    )
  end

  def clear_omni_auth_mock
    OmniAuth.config.mock_auth[:github] = nil
  end

  def sign_up_with_github(user = FactoryBot.build(:user))
    visit root_path
    mock_omin_auth_providers(user)
    click_button "Continue with Github"
  end
end
