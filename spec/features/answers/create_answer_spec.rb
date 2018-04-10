require 'rails_helper'

feature 'Answer the question', %q{
  In order to help and share my knowledge
  As logged in user
  I want to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User answers' do
    sign_in(user)
    visit question_path(question)

    data = attributes_for(:answer)

    within '#new_answer' do
      fill_in 'Your answer', with: data[:body]
      click_button 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully created.'
    expect(page).to have_content data[:body]
  end

  scenario 'User attempts to answers with invalid data' do
    sign_in(user)
    visit question_path(question)

    within '#new_answer' do
      fill_in 'Your answer', with: ''
      click_button 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Please review the problems below'
  end

  scenario 'Guest attempts to answers' do
    visit question_path(question)
    expect(page).not_to have_selector '#new_answer'
    expect(page).to have_link 'Sign in to answer the Question'
  end
end