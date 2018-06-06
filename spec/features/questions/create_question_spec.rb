require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
} do

  given(:user) { create(:user) }

  feature 'multiple sessions', :js do
    scenario 'question appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        within '#new_question' do
          fill_in 'Title', with: 'Some question'
          fill_in 'Body', with: 'Some body'
          click_on 'Create'
        end

        expect(page).to have_content 'Some question'
        expect(page).to have_content 'Some body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Some question'
      end
    end
  end

  scenario 'Authenticated user create the question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    data = attributes_for(:question)

    within '#new_question' do
      fill_in 'Title', with: data[:title]
      fill_in 'Body', with: data[:body]
      click_button 'Create'
    end

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content data[title]
    expect(page).to have_content data[body]
  end

  scenario 'User attempts to create a question with invalid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_button 'Create'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Title -can\'t be blank'
    expect(page).to have_content 'Body - can\'t be blank'
  end

  scenario 'Non-authenticated user try to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
