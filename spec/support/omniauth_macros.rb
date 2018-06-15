module OmniauthMacros
  def mock_auth(provider)
    data = { provider: provider, uid: '123456', info: { email: 'test@test.com' } }
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(data)
  end

  def mock_auth_invalid(provider)
    OmniAuth.config.mock_auth[provider] = :credentials_are_invalid
  end

  def mock_auth_without_email(provider)
    data = { provider: provider, uid: '123456', info: {} }
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(data)
  end
end