class Subscribe < ApplicationRecord
  include Authorable

  belongs_to :question

  validates :question_id, uniqueness: { scope: :user_id }
end