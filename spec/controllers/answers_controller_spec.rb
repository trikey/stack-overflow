require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
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
  end

  describe 'DELETE #destroy' do
    before { answer }

    it 'deletes answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to answer.question
    end
  end
end
