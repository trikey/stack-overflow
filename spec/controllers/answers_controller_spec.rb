require 'rails_helper'

describe AnswersController do
  it_behaves_like 'voted'

  let(:question) { create(:question) }
  let(:answer) { create(:answer, user: subject.current_user) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    login_user
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }.
          to change(question.answers, :count).by(1)
      end

      it 'connects answer to user after create' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }.
          to change(subject.current_user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    login_user
    context 'author updates answer with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to the question show view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer.question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: answer, answer: { body: nil } } }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'Answer for question'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'not author tries to update answer' do
      before {
        @answer = create(:answer, user: user)
        patch :update, params: { id: @answer, answer: { body: 'new body' } }
      }
      it 'can not update answer' do
        @answer.reload
        expect(@answer.body).not_to eq 'new body'
      end

      it 'redirect to answers\'s question page' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user
    context 'author' do
      before { answer }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'not author' do
      before { @answer = create(:answer, user: user) }
      it 'can not delete answer' do
        expect { delete :destroy, params: { id: @answer.id } }.to_not change(Answer, :count)
      end

      it 'redirect to answers\'s question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end


  describe 'PATCH #best' do
    login_user
    context 'author' do
      let!(:question) { create(:question, user: subject.current_user) }
      let!(:answer1) { create(:answer, question: question) }
      let!(:answer2) { create(:answer, question: question, best: true) }

      before do
        patch :best, params: { id: answer1, format: :js }
      end

      it 'assigns answer' do
        expect(assigns(:answer)).to eq answer1
      end

      it 'set answer as best' do
        expect(answer1.reload).to be_best
        expect(answer2.reload).to_not be_best
      end

      it 'redirect to question' do
        expect(response).to redirect_to answer1.question
      end
    end

    context 'not author' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it 'can not set answer as best' do
        expect { patch :best, params: { id: answer, format: :js } }.to_not change(answer, :best)
      end

      it 'get 403 status :forbidden' do
        patch :best, params: { id: answer, format: :js }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
