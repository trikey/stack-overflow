require 'rails_helper'

feature 'Sign in via Twitter', %q{
  In order to sign in without typing email & password
  As a user
  I want to be able to sign in with Twitter account
} do

  background do
    clear_emails
    visit new_user_session_path
  end

  scenario 'User tries to sign up with Twitter' do
    mock_auth_without_email(:twitter)
    click_on 'Sign in with Twitter'

    email = 'test@test.com'

    expect(page).to have_content('Please enter your email before continuing')
    fill_in 'Email', with: email
    click_on 'Send'

    open_email(email)
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  context 'with invalid credentials' do
    scenario 'user not sign_in' do
      mock_auth_invalid(:twitter)
      click_link 'Sign in with Twitter'
      expect(page).to have_content('Could not authenticate you from Twitter because "Credentials are invalid"')
    end
  end
end