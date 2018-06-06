class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true, index: true
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
