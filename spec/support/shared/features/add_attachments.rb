shared_examples_for 'Add attachments' do
  background do
    sign_in(user)
    visit path
  end

  scenario 'User adds files when asks the question', :js do
    fill_in 'Title', with: 'Title placeholder' if title?
    fill_in "#{text_input}", with: 'Placeholder for body'
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

    click_on "#{submit_btn}"

    within "#{attachment_block}" do
      expect(page).to have_link 'img.jpg'
      expect(page).to have_link 'img2.jpg'
      expect(page).to_not have_link 'img3.jpg'
    end
  end
end