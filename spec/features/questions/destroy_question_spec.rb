require 'rails_helper'

feature 'Delete question', %q{
  In order to remove question
  As the user who created question
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User deletes his question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Question was successfully deleted.'
    expect(page).not_to have_content question.body
  end

  scenario 'User attempts to delete someone else question' do
    sign_in(user)
    visit question_path(create(:question))

    expect(page).not_to have_link 'Delete'
  end

  scenario 'Guest attempts to delete question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end
