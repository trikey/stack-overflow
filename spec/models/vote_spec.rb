require 'rails_helper'

RSpec.describe Vote, type: :model do
  it_behaves_like 'Authorable'

  it { should belong_to :votable }

  it { should validate_inclusion_of(:votable_type).in_array(%w(Question Answer)) }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  it do
    subject.user = create(:user)

    should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id)
               .with_message('You have already voted')
  end

  it 'validates that voting user not user votable object' do
    user = create(:user)
    question = create(:question, user_id: user.id)
    vote = question.votes.build(user_id: user.id, value: 1)
    vote.valid?

    expect(vote.errors[:user_id]).to eq(['You can not vote for your question'])
  end

  describe '#need_unvote?' do
    let(:john) { create(:user) }
    let(:bob) { create(:user) }
    let(:question) { create(:question, user_id: john.id) }

    it 'need' do
      vote = create(:vote, votable: question, user_id: bob.id, value: 1)
      expect(vote.need_unvote?(1)).to eq(true)
    end

    it 'not needed' do
      vote = question.votes.build(user_id: bob.id, value: -1)
      expect(vote.need_unvote?(1)).to eq(false)
    end
  end
end