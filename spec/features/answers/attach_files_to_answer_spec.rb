require 'rails_helper'

feature 'Add files to answers', %q(
  In order to illustrate my answer
  As an author of the answer
  I'd like to be able to attach files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:path) { question_path(question) }
  given(:title?) { false }
  given(:submit_btn) { 'Create Answer' }
  given(:attachment_block) { '.answers' }
  given(:text_input) { 'Your answer' }


  it_behaves_like 'Add attachments'
end