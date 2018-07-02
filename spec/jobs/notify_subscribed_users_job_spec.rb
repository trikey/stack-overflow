require 'rails_helper'

RSpec.describe NotifySubscribedUsersJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:subscribes) { create_list(:subscribe, 2, question: question) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'send notify to subscribed users' do
    question.subscribes.each do |subscribe|
      expect(NotifySubscribersMailer).to receive(:notify).with(subscribe.user, answer).and_call_original
    end
    NotifySubscribedUsersJob.perform_now(answer)
  end
end