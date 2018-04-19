require 'rails_helper'

feature 'Best answer', %q{
  To mark answer as solution for question
  As an author of the question
  I want to be able to mark the mark answer as best
} do

  given!(:user) { create(:user) }
  let(:question) { create(:question_with_answers) }

  scenario 'Unauthorized user can not mark the answer as best' do
    visit question_path(question)
    expect(page).to_not have_link('Best')
  end

  describe 'Authorized user' do
    before {
      sign_in(user)
      @question = create(:question, user: user)
      @answer1 = create(:answer, question: @question)
      @answer2 = create(:answer, question: @question, best: true)
    }

    scenario 'as author of question can mark the answer as best', js: true do
      visit question_path(@question)

      within "#answer_#{@answer1.id}" do
        click_on 'Make Best'

        expect(page).to have_content 'Best answer'
        expect(page).to_not have_link('Make Best')
      end

      within "#answer_#{@answer2.id}" do
        expect(page).to have_link('Make Best')
        expect(page).to_not have_content 'Best answer'
      end

      expect(page).to have_content 'Answer marked as best'

      first_answer = page.find(:css, '.answer', match: :first).text
      expect(first_answer).to have_content @answer1.body
      expect(first_answer).to have_content 'Best answer'
    end

    scenario 'as non author of the question can not mark the answer as best' do
      visit question_path(question)
      expect(page).to_not have_link 'Make Best'
    end
  end

end