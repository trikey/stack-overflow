class AddUsersToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :user, index: true, null: false
  end
end
