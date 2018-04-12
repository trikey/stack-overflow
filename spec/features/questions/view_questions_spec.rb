require 'rails_helper'

feature 'View questions', %q{
  In order to find questions
  As an user
  I want to be able view questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'User views questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
