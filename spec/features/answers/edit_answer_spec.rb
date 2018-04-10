require 'rails_helper'

feature 'Edit answer', %q{
  In order to make adjustments
  As respondent
  I want to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:data) { { body: 'Forty-one' } }

  scenario 'Respondent edits his answer', js: true do
    sign_in user
    visit question_path(question)
    click_on('Edit')

    expect(current_path).to eq question_path(question)

    within "#edit_answer_#{answer.id}" do
      fill_in 'Your answer', with: data[:body]
      click_button 'Update Answer'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully updated.'
    expect(page).to have_content data[:body]
    expect(page).not_to have_content answer.body
  end

  scenario 'Respondent cancels his corrections', js: true do
    sign_in user
    visit question_path(question)
    click_on('Edit')

    within "#edit_answer_#{answer.id}" do
      fill_in 'Your answer', with: data[:body]
      click_on 'Cancel'
    end

    expect(page).to have_content answer.body
    expect(page).not_to have_content data[:body]
  end

  scenario 'User attempts to edit somebody\'s else answer'  do
    sign_in create(:user)
    visit question_path(question)

    expect(answer_section(answer)).not_to have_link 'Edit'
  end

  scenario 'Guest attempts to edit some answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end