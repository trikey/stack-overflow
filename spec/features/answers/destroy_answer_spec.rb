require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove answer
  As respondent
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'User deletes his answer', js: true do
    sign_in user
    visit question_path(question)

    within answer_html(answer) do
      click_on('Delete')
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully deleted.'
    expect(page).not_to have_content answer.body
  end

  scenario 'User attempts to delete someone else answer' do
    sign_in create(:user)
    visit question_path(question)

    expect(answer_html(answer)).not_to have_link 'Delete'
  end

  scenario 'Guest attempts to delete answer' do
    visit question_path(question)

    expect(answer_html(answer)).not_to have_link 'Delete'
  end
end
