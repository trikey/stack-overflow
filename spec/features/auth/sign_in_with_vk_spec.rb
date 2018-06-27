require 'rails_helper'

feature 'Sign in via Vkontakte', %q{
  In order to sign in without typing email & password
  As a user
  I want to be able to sign in with Vkontakte account
} do
  let(:provider) { 'vkontakte' }
  it_behaves_like 'Oauth with enter email'
end