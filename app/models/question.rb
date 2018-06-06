class Question < ApplicationRecord
  include Attachable
  include Authorable
  include Votable
  include Commentable

  has_many :answers, -> { order('best desc') }, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
