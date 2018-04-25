require 'rails_helper'

feature 'Delete answer attachment', %q(
  In order to remove wrong file
  As an author of the answer
  I want to be able to remove attachment
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Unauthorized user can not delete attachment' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authorized user' do
    scenario 'can delete his attachment', :js do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        click_on "delete_#{attachment.file.identifier}"
        click_on 'Update'
      end

      expect(page).to_not have_content 'img.jpg'
    end

    scenario 'can not delete someone else answer attachment', :js do
      sign_in user
      someone_answer = create(:answer, question: question, user: create(:user))
      visit question_path(question)

      within "#answer_#{someone_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end