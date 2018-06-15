require 'rails_helper'

feature 'Sign in via Vkontakte', %q{
  In order to sign in without typing email & password
  As a user
  I want to be able to sign in with Vkontakte account
} do

  background do
    clear_emails
    visit new_user_session_path
  end

  scenario 'User tries to sign up with Vkontakte' do
    mock_auth(:vkontakte)
    click_on 'Sign in with Vkontakte'

    open_email('test@test.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  context 'with invalid credentials' do
    scenario 'user not sign_in' do
      mock_auth_invalid(:vkontakte)
      click_link 'Sign in with Vkontakte'
      expect(page).to have_content('Could not authenticate you from Vkontakte because "Credentials are invalid"')
    end
  end
end