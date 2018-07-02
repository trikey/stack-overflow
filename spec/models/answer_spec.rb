require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'Votable'
  it_behaves_like 'Commentable'
  it_behaves_like 'Authorable'
  it_behaves_like 'Attachable'

  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  describe '#make_best' do
    let(:question) { create(:question) }

    it 'set best answer if it is not set yet' do
      answer = create(:answer, question: question)
      answer.make_best
      answer.reload

      expect(answer).to be_best
    end

    it 'set new best answer if it is already set' do
      answer1 = create(:answer, question: question, best: true)
      answer2 = create(:answer, question: question)

      answer2.make_best

      answer1.reload
      answer2.reload

      expect(answer1).to_not be_best
      expect(answer2).to be_best
    end
  end

  describe '.send_notification' do
    let(:question) { create(:question) }
    let!(:subscribes) { create_list(:subscribe, 2, question: question) }
    subject { build(:answer, question: question) }

    it 'should send notification to all subscribe users after create answer' do
      question.subscribes do
        expect(NotifySubscribedUsersJob).to receive(:perform).with(subject).and_call_original
      end
      subject.save!
    end

    it 'should not send notification after update answer' do
      subject.save!
      expect(subject).to_not receive(:notify_subscribed_users)
      subject.update(body: 'This is updated body')
    end
  end
end