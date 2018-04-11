require 'rails_helper'

feature 'View questions', %q{
  In order to find questions
  As an user
  I want to be able view questions
} do

  given(:user) { create(:user) }

  scenario 'User views questions' do
    questions = create_list(:question, 2)
    visit questions_path

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end
end
