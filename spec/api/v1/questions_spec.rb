require 'rails_helper'

describe 'Questions API', type: :request do
  describe 'GET /index' do
    let(:http_method) { :get }
    let(:url) { api_v1_questions_path }

    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }

      before { do_request(http_method, url, { access_token: access_token.token } ) }

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
    let(:http_method) { :get }
    let(:url) { api_v1_question_path(question) }

    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question, user: create(:user)) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let(:json_root_path) { 'question' }

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

      it_behaves_like 'API comments'
      it_behaves_like 'API attachments'
    end
  end

  describe 'POST /create' do
    let(:http_method) { :post }
    let(:url) { api_v1_questions_path }

    it_behaves_like 'API unauthorized'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid question params' do
        before {
          @question_attrs = attributes_for(:question)
          do_request(:post, api_v1_questions_path, { question: @question_attrs, format: :json, access_token: access_token.token } )
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
        before { do_request(:post, api_v1_questions_path, { question: attributes_for(:invalid_question), access_token: access_token.token } ) }

        it 'returns 422 status code' do
          expect(response).to have_http_status 422
        end

        it 'returns errors list' do
          expect(response.body).to have_json_size(2).at_path('errors')
        end

        %w(title body).each do |attr|
          it "returns #{attr} presence error" do
            expect(response.body).to be_json_eql('can\'t be blank'.to_json).at_path("errors/#{attr}/0")
          end
        end
      end
    end
  end
end