require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:nullify) }
  it { should have_many(:answers).dependent(:nullify) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscribes).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new('devise.provider': 'vkontakte', 'devise.uid': '123456') }

    context 'user alredy has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new('devise.provider': 'vkontakte', 'devise.uid': '123456', 'devise.email': user.email) }

        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth['devise.provider']
          expect(authorization.uid).to eq auth['devise.uid']
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to eq(user)
        end
      end

      context 'user does not exist' do
        context 'provider has email' do
          let(:auth) { OmniAuth::AuthHash.new('devise.provider': 'vkontakte', 'devise.uid': '123456', 'devise.email': 'new@user.com') }

          it 'creates new user' do
            expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
          end

          it 'returns new user' do
            expect(User.find_for_oauth(auth)).to be_a(User)
          end

          it 'fills user email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth['devise.email']
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it 'creates authorizations with provider and uid' do
            authorization = User.find_for_oauth(auth).authorizations.first
            expect(authorization.provider).to eq auth['devise.provider']
            expect(authorization.uid).to eq auth['devise.uid']
          end
        end

        context 'provider has not email' do
          let(:auth) { OmniAuth::AuthHash.new('devise.provider': 'vkontakte', 'devise.uid': '123456') }

          it 'should not initialize user' do
            expect(User.find_for_oauth(auth)).to be_nil
          end
        end
      end
    end

    context 'not provide auth' do
      it 'return nil if not set auth' do
        auth_params = {}
        expect(User.find_for_oauth(auth_params)).to be_nil
      end

      it 'return nil if not set auth.provider' do
        auth = OmniAuth::AuthHash.new('devise.uid': '123456')
        expect(User.find_for_oauth(auth)).to be_nil
      end

      it 'return nil if not set auth.uid' do
        auth = OmniAuth::AuthHash.new('devise.provider': 'vkontakte')
        expect(User.find_for_oauth(auth)).to be_nil
      end
    end
  end

  describe '.new_with_session' do
    subject { User.new_with_session(params, session) }
    let!(:session) { { 'devise.authorization' => { provider: 'vkontakte', uid: '123456' } } }

    context 'user exist' do
      let!(:user) { create(:user) }
      let!(:params) { { email: user.email } }

      it "reset confirmed_at" do
        subject
        expect(user.reload.confirmed_at).to be_nil
      end

      it "return user" do
        expect(subject).to eq user
      end
    end

    context 'user not exist' do
      context 'provide email param' do
        let(:params) { { email: 'example@mail.com' } }

        it 'return new user' do
          expect(subject).to be_new_record
          expect(subject).to be_a(User)
        end

        it 'return valid user' do
          expect(subject).to be_valid
        end
      end

      context 'not provide email param' do
        let(:params) { {} }

        it 'return new user' do
          expect(subject).to be_new_record
          expect(subject).to be_a(User)
        end

        it 'return not valid user' do
          expect(subject).to_not be_valid
        end
      end
    end
  end

  describe '#password_required?' do
    let!(:user) { create(:user) }

    context 'without authorizations' do
      it 'return true' do
        expect(user.password_required?).to be_truthy
      end
    end

    context 'with authorization' do
      it 'return false' do
        create(:authorization, user: user)
        expect(user.reload.password_required?).to be_falsey
      end
    end
  end

  describe '#update_with_password' do
    let!(:params) { { email: 'example@mail.com' } }

    it 'update user without password' do
      user = User.new
      user.authorizations.build
      user.save
      user.update_with_password(params)
      expect(user.reload.email).to eq params[:email]
    end
  end

  describe '#has_subscribe?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    it 'user has subscribe to question' do
      user.subscribes.create(question_id: question.id)
      expect(user.has_subscribe?(question)).to be_truthy
    end

    it 'user has not subscribe to question' do
      expect(user.has_subscribe?(question)).to be_falsey
    end
  end

  describe '#get_subscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'get subscribe for question' do
      subscribe = user.subscribes.create(question_id: question.id)
      expect(user.get_subscribe(question)).to eq(subscribe)
    end
  end
end
