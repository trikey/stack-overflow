require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'Votable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Authorable'
  it_behaves_like 'Attachable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribes).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'question for last day' do
    let!(:questions) { create_list(:question, 2) }
    let!(:question_2_days_later) { create(:question, created_at: (Time.now - 2.days)) }

    it 'returns questions created last day' do
      expect(Question.last_day).to match_array(questions)
    end

    it 'not return question created earlire last day' do
      expect(Question.last_day).to_not include(question_2_days_later)
    end
  end

  describe 'subscribe' do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }

    it 'should subscribe after create' do
      expect(subject).to receive(:subscribe_author)
      subject.save!
    end

    it 'should not subscribe after update question' do
      subject.save!
      expect(subject).to_not receive(:subscribe_author)
      subject.update(body: 'This is updated body')
    end
  end
end
