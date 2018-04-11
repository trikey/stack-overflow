require 'rails_helper'

feature 'Log out', %q{
  In order to relogin or close session
  As logged in user
  I want to logout
} do

  scenario 'Logged in user logs out' do
    sign_in create(:user)
    click_on 'Sign out'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end
end
