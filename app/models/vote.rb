class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :votable_type, inclusion: { in: %w(Question Answer) }
  validates :value, inclusion: { in: [-1, 1] }
  validates :user_id,
            uniqueness: { scope: [:votable_type, :votable_id], message: 'You have already voted' }
  validate  :not_votable_author

  def need_unvote?(value)
    persisted? && self.value == value
  end

  private

  def not_votable_author
    if votable && self.user_id == votable.user_id
      errors[:user_id] << "You can not vote for your #{votable.model_name.singular}"
    end
  end
end
