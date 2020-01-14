module AuthSystemTestHelper
  def mock_omin_auth_providers(member)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      member.provider,
      uid: member.provider_id, info: { name: member.name, email: member.email },
    )
  end

  def clear_omni_auth_mock
    OmniAuth.config.mock_auth[:github] = nil
  end

  def sign_up_with_github(member = FactoryBot.build(:member))
    visit root_path
    mock_omin_auth_providers(member)
    click_button "Continue with Github"
  end
end
