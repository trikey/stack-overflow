require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get api_v1_questions_path, params: { format: :json }
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if access_token is invalid' do
        get api_v1_questions_path, params: { format: :json, access_token: '123456' }
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }

      before { get api_v1_questions_path, params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at user_id).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get api_v1_question_path(question), params: { format: :json }
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if access_token is invalid' do
        get api_v1_question_path(question), params: { format: :json, access_token: '123456' }
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question, user: create(:user)) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get api_v1_question_path(question), params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns question' do
        expect(response.body).to have_json_path('question')
      end

      %w(id title body created_at updated_at user_id).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body created_at updated_at commentable_id commentable_type user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it "contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', params: { question: attributes_for(:question), format: :json }
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: '123456' }
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid question params' do
        before {
          @question_attrs = attributes_for(:question)
          post '/api/v1/questions', params: { question: @question_attrs, format: :json, access_token: access_token.token }
        }
        it 'returns 201 status code' do
          expect(response).to have_http_status 201
        end

        it 'returns created question' do
          expect(response.body).to have_json_path('question')
        end

        %w(title body).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(@question_attrs[attr.to_sym].to_json).at_path("question/#{attr}")
          end
        end
      end

      context 'with invalid question params' do
        before { post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }
        it "returns 422 status code" do
          expect(response).to have_http_status 422
        end

        it 'returns errors list' do
          expect(response.body).to have_json_size(2).at_path('errors')
        end

        %w(title body).each do |attr|
          it "returns #{attr} presence error" do
            expect(response.body).to be_json_eql("can't be blank".to_json).at_path("errors/#{attr}/0")
          end
        end
      end
    end
  end
end