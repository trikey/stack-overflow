require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:nullify) }
  it { should have_many(:answers).dependent(:nullify) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:authored_question) { create(:question, user: user) }

    it 'user is the author of the question' do
      expect(user).to be_author_of(authored_question)
    end

    it 'user is not author of the question' do
      expect(user).to_not be_author_of(question)
    end
  end
end
