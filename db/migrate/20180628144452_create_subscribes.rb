class CreateSubscribes < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribes do |t|
      t.belongs_to :question, foreign_key: true, index: true
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
