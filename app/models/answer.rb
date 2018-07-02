class Answer < ApplicationRecord
  include Attachable
  include Authorable
  include Votable
  include Commentable

  belongs_to :question

  after_create :notify_subscribed_users

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def make_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

  private

  def notify_subscribed_users
    NotifySubscribedUsersJob.perform_later(self)
  end
end
