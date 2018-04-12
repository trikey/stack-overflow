require 'rails_helper'

feature 'Answer the question', %q{
  In order to give answer to question available to all
  As logged in user
  I want to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'User answers the question' do
    sign_in(user)
    visit question_path(question)

    data = attributes_for(:answer)

    within '#new_answer' do
      fill_in 'Your answer', with: data[:body]
      click_button 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content data[:body]
  end

  scenario 'User attempts to answer with invalid data' do
    sign_in(user)
    visit question_path(question)

    within '#new_answer' do
      fill_in 'Your answer', with: ''
      click_button 'Create Answer'
    end

    expect(current_path).to eq question_answers_path(question)
    expect(page).to have_content 'Your answer -can\'t be blank'
  end

  scenario 'Guest attempts to answers' do
    visit question_path(question)
    expect(page).not_to have_selector '#new_answer'
    expect(page).to have_link 'Sign in to answer the Question'
  end
end
