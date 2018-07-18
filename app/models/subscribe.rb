class Subscribe < ApplicationRecord
  include Authorable

  belongs_to :question, touch: true

  validates :question_id, uniqueness: { scope: :user_id }
end