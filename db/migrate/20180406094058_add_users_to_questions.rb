class AddUsersToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :user, index: true, null: false
  end
end
