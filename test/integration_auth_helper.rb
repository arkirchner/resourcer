module IntegrationAuthHelper
  def sign_in_as(member)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      member.provider,
      uid: member.provider_id, info: { name: member.name },
    )
    get "/auth/#{member.provider}/callback"
    assert_response :redirect
    OmniAuth.config.mock_auth[member.provider.to_sym] = nil
  end
end
