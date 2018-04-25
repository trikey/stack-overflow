require 'rails_helper'

feature 'Delete question attachment', %q(
  In order to remove wrong file
  As an author of the question
  I want to be able to remove attachment
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Unauthorized user can not delete attachment' do
    visit question_path(question)
    expect(page).to_not have_link('Edit')
  end

  describe 'Authorized user' do
    scenario 'can delete his attachment', :js do
      sign_in(user)
      visit edit_question_path(question)

      click_on "delete_#{attachment.file.identifier}"
      click_button 'Update Question'

      expect(page).to_not have_content 'img.jpg'
    end

    scenario 'can not delete someone else question attachment', :js do
      question.update(user: create(:user))
      visit question_path(question)
      expect(page).to_not have_link('Edit')
    end
  end
end