require 'rails_helper'

feature 'Sign in via Twitter', %q{
  In order to sign in without typing email & password
  As a user
  I want to be able to sign in with Twitter account
} do

  let(:provider) { 'twitter' }
  it_behaves_like 'Oauth with enter email'
end