require 'rails_helper'

feature 'Attach files to answers', %q(
  In order to be more specific at my answer
  As an author of the answer
  I want to be able to attach files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  before {
    sign_in(user)
    visit question_path(question)
  }

  scenario 'User adds file when asks the question', js: true do
    fill_in 'Your answer', with: 'Some booody'
    attach_file 'File', "#{Rails.root}/spec/fixtures/img.jpg"

    click_on 'add file'

    within '.nested_fields:nth-child(2)' do
      attach_file 'File', "#{Rails.root}/spec/fixtures/img2.jpg"
    end

    click_on 'add file'

    within '.nested_fields:nth-child(3)' do
      attach_file 'File', "#{Rails.root}/spec/fixtures/img3.jpg"
      click_on 'remove file'
    end

    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'img.jpg', href: '/uploads/attachment/file/1/img.jpg'
      expect(page).to have_link 'img2.jpg', href: '/uploads/attachment/file/2/img2.jpg'
      expect(page).to_not have_link 'img3.jpg', href: '/uploads/attachment/file/3/img3.jpg'
    end
  end
end