class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :user, foreign_key: true, null: false
      t.integer :value

      t.timestamps
    end
  end
end
