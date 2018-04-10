require 'rails_helper'

feature 'Edit question', %q{
  In order to change question data
  As the user who created question
  I want to edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Questioner edits his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Edit'

    expect(current_path).to eq edit_question_path(question)

    data = {
        title: 'What have I got in my pocket?',
        body: 'You said ask me a question. Well, that is my question.'
    }

    within "#edit_question_#{question.id}" do
      fill_in 'Title', with: data[:title]
      fill_in 'Body', with: data[:body]
      click_button 'Update Question'
    end

    expect(current_path).to eq question_path(question)
    expect(notice).to have_content 'Question was successfully updated.'

    within question_section do
      expect(page).to have_content data[:title]
      expect(page).to have_content data[:body]
      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
    end
  end

  scenario 'User attempts to edit somebody\'s else question' do
    sign_in(user)
    visit question_path(create(:question))

    expect(page).not_to have_link 'Edit'
  end

  scenario 'Guest attempts to edit some question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end
end