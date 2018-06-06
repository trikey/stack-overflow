require 'rails_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user' do
    context 'user edits his question' do
      before do
        sign_in user
        visit question_path(question)
      end

      scenario 'sees link to Edit' do
        within '.answers' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'try to edit his answer', js: true do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Update'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
        end
      end
    end

    scenario 'try to edit other user\'s question' do
      sign_in user
      someone_answer = create(:answer, question: question, user: create(:user))
      visit question_path(question)

      within "#answer_#{someone_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end