require 'rails_helper'

feature 'Register', %q{
  In order to login I need to register
  As guest
  I want to register
} do

  scenario 'Guest registers with valid data' do
    visit root_path
    click_on 'Sign up'

    expect(current_path).to eq new_user_registration_path

    user = attributes_for(:user)

    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: user[:password], match: :prefer_exact
    fill_in 'Password confirmation', with: user[:password_confirmation], match: :prefer_exact
    click_button 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Guest registers with invalid data' do
    visit new_user_registration_path

    fill_in 'Email', with: 'bugaga'
    fill_in 'Password', with: 'password', match: :prefer_exact
    fill_in 'Password confirmation', with: 'other-password', match: :prefer_exact
    click_button 'Sign up'

    expect(current_path).to eq user_registration_path
    expect(page).to have_content 'prohibited this user from being saved'
  end

  scenario 'Logged in user attempts to register' do
    sign_in create(:user)
    visit new_user_registration_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'You are already signed in.'
  end
end