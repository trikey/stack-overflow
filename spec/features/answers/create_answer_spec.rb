require 'rails_helper'

feature 'Answer the question', %q{
  In order to give answer to question available to all
  As logged in user
  I want to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  feature 'Multiple sessions', :js do
    scenario 'answer appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'Some answer'
        click_on 'Create Answer'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Some answer'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Some answer'
        end
      end
    end
  end

  scenario 'User answers the question', js: true do
    sign_in(user)
    visit question_path(question)

    data = attributes_for(:answer)

    within '#new_answer' do
      fill_in 'Your answer', with: data[:body]
      click_button 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content data[:body]
    end
  end

  scenario 'User attempts to answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)

    within '#new_answer' do
      fill_in 'Your answer', with: ''
      click_button 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer -can\'t be blank'
  end

  scenario 'Guest attempts to answers', js: true do
    visit question_path(question)
    expect(page).not_to have_selector '#new_answer'
    expect(page).to have_link 'Sign in to answer the Question'
  end
end
