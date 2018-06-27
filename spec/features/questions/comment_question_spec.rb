require 'rails_helper'

feature 'Add comments for question', %q(
  In order to clarify the issue
  As an authorized user
  I'd like to be able to add comment for question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:comments_block) { '.question .comments' }

  it_behaves_like 'Feature add comments'
end