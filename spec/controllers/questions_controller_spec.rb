require 'rails_helper'

describe QuestionsController do
  it_behaves_like 'voted'

  let(:question) { create(:question, user: @user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    login_user
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    login_user
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'build new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    login_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    login_user
    before { get :edit, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    login_user
    let(:parameters) { { question: attributes_for(:question) } }
    subject { post :create, params: parameters }

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { subject }.
          to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        subject
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:parameters) { { question: attributes_for(:invalid_question) } }
      it 'does not save the question' do
        expect { subject }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    login_user
    let(:parameters) do
      { id: question, question: { title: 'new title', body: 'new body' } }
    end

    subject { patch :update, params: parameters }

    context 'author tries to update question with valid attributes' do
      context 'assings the requested question' do
        let(:parameters) do
          { id: question, question: attributes_for(:question) }
        end
        it 'to @question' do
          subject
          expect(assigns(:question)).to eq question
        end
      end

      it 'changes question attributes' do
        subject
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'not author tries to update question' do
      before {
        @question = create(:question, user: user)
        subject
      }
      it 'can not update question' do
        @question.reload
        expect(@question.title).not_to eq 'new title'
        expect(@question.body).not_to eq 'new body'
      end

      it 'redirect to question\'s question page' do
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      let(:parameters) { { id: question, question: { title: nil } } }

      before { subject }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).not_to eq 'new title'
        expect(question.body).not_to eq nil
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user
    subject { delete :destroy, params: { id: question } }

    context 'author' do
      before { question }

      it 'deletes question' do
        expect { subject }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        subject
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      before { question.update(user: user) }
      it 'can not delete question' do
        expect { subject }.to_not change(Question, :count)
      end

      it 'redirect to index view' do
        subject
        expect(response).to redirect_to root_path
      end
    end
  end
end
