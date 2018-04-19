class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order('best desc') }, dependent: :destroy

  validates :title, :body, presence: true
end
