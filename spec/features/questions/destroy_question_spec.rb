require 'rails_helper'

feature 'Delete question', %q{
  In order to remove the unneeded question
  As the questioner
  I want to be able to destroy it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Questioner deletes his question' do
    sign_in(user)
    visit question_path(question)

    selector = "[data-question='#{question.id}']"
    expect(page).to have_selector selector

    question_section.click_on('Delete')

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Question was successfully deleted.'
    expect(page).not_to have_selector selector
  end

  scenario 'User attempts to delete somebody\'s else question' do
    sign_in(user)
    visit question_path(create(:question))

    expect(page).not_to have_link 'Delete'
  end

  scenario 'Guest attempts to delete some question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end