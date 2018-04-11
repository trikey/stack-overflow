require 'rails_helper'

feature 'Edit question', %q{
  In order to change question data
  As the user who created question
  I want to edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User edits his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Edit'

    expect(current_path).to eq edit_question_path(question)

    question_data = {
      title: 'Such question?',
      body: 'Much wow'
    }

    within "#edit_question_#{question.id}" do
      fill_in 'Title', with: question_data[:title]
      fill_in 'Body', with: question_data[:body]
      click_button 'Update Question'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Question was successfully updated.'

    expect(page).to have_content question_data[:title]
    expect(page).to have_content question_data[:body]
    expect(page).not_to have_content question.title
    expect(page).not_to have_content question.body
  end

  scenario 'User attempts to edit someone else question' do
    sign_in(user)
    visit question_path(create(:question))

    expect(page).not_to have_link 'Edit'
  end

  scenario 'Guest attempts to edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end
