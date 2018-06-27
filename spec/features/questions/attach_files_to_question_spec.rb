require 'rails_helper'

feature 'Add files to questions', %q(
  In order to be more specific at my question
  As an author of the question
  I want to be able to attach files
) do
  given(:user) { create(:user) }
  given(:path) { new_question_path }
  given(:title?) { true }
  given(:submit_btn) { 'Create' }
  given(:attachment_block) { '.question' }
  given(:text_input) { 'Body' }

  it_behaves_like 'Add attachments'
end