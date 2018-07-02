class Question < ApplicationRecord
  include Attachable
  include Authorable
  include Votable
  include Commentable

  has_many :answers, -> { order('best desc') }, dependent: :destroy
  has_many :subscribes, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_author

  scope :last_day, -> {  where('created_at >= ?', (Date.today - 1.day).to_time) }

  private

  def subscribe_author
    subscribes.create(user: user)
  end
end
