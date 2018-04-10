require 'rails_helper'

feature 'Delete answer', %q{
  In order to remove the unneeded answer
  As respondent
  I want to be able to destroy it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Respondent deletes his answer' do
    sign_in user
    visit question_path(question)

    click_on('Delete')

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully deleted.'
    expect(page).not_to have_selector "[data-answer='#{answer.id}']"
  end

  scenario 'User attempts to delete somebody\'s else answer' do
    sign_in create(:user)
    visit question_path(question)

    expect(body).not_to have_link 'Delete'
  end

  scenario 'Guest attempts to delete some answer' do
    visit question_path(question)

    expect(body).not_to have_link 'Delete'
  end
end