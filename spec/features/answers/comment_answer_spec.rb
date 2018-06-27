require 'rails_helper'

feature 'Add comments for answer', %q(
  In order to clarify the issue
  As an authorized user
  I'd like to be able to add comment for answer
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:comments_block) { "#answer_#{answer.id} .comments" }

  it_behaves_like 'Feature add comments'
end