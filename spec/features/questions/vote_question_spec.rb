require 'rails_helper'

feature 'Vote for question', %(
  In order to show my opinion about question
  As an authorized user
  I'd like to be able to vote for question
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthorized user can not vote for question', :js do
    visit question_path(question)
    within '.rating_block' do
      find(:css, '.glyphicon-chevron-up').click

      expect(page).to have_content '0'
    end
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Authorized user' do
    before { sign_in(user) }

    describe 'as author this question' do
      scenario 'can not vote', :js do
        question.update(user_id: user.id)
        visit question_path(question)

        within '.rating_block' do
          find(:css, '.glyphicon-chevron-up').click

          expect(page).to have_content '0'
        end
        expect(page).to have_content 'You are not authorized to access this page'
      end
    end

    describe 'as not author this question' do
      scenario 'can vote up', :js do
        visit question_path(question)

        within '.rating_block' do
          find(:css, '.glyphicon-chevron-up').click

          expect(page).to have_content '1'
        end
        expect(page).to have_content 'You voted for question'
      end

      scenario 'can vote down', :js do
        visit question_path(question)

        within '.rating_block' do
          find(:css, '.glyphicon-chevron-down').click

          expect(page).to have_content '-1'
        end
        expect(page).to have_content 'You voted for question'
      end

      scenario 'can change vote', :js do
        question.votes.create(user: user, value: 1)
        visit question_path(question)

        within '.rating_block' do
          expect(page).to have_content '1'

          find(:css, '.glyphicon-chevron-down').click

          expect(page).to have_content '-1'
        end
        expect(page).to have_content 'You voted for question'
      end

      scenario 'can unvote', :js do
        question.votes.create(user: user, value: 1)
        visit question_path(question)

        within '.rating_block' do
          expect(page).to have_content '1'

          find(:css, '.glyphicon-chevron-up').click

          expect(page).to have_content '0'
        end
        expect(page).to have_content 'You unvoted for question'
      end
    end

  end
end