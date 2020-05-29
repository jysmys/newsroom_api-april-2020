# frozen_string_literal: true

RSpec.describe 'Api::Admin::Articles :index', type: :request do
  let!(:articles) { 5.times { create(:article, published: true) } }
  let!(:unpublished_articles) { 7.times { create(:article) } }

  let(:editor) { create(:user, role: 'editor') }
  let(:editors_credentials) { editor.create_new_auth_token }
  let(:editors_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(editors_credentials) }

  let(:journalist) { create(:user, role: 'journalist') }
  let(:journalist_credentials) { journalist.create_new_auth_token }
  let(:journalist_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(journalist_credentials) }

  describe 'GET /api/admin/articles' do
    before do
      get '/api/admin/articles', headers: editors_headers
    end

    it 'has a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'has returns all unpublished articles' do
      expect(response_json['articles'].length).to eq 7
    end

    describe 'response has keys' do
      it ':title' do
        expect(response_json['articles'][0]).to have_key 'title'
      end

      it ':category' do
        expect(response_json['articles'][0]).to have_key 'category'
      end

      it ':created_at' do
        expect(response_json['articles'][0]).to have_key 'created_at'
      end
    end
  end

  describe 'GET /api/admin/articles unauthorized' do
    before do
      get '/api/admin/articles', headers: journalist_headers
    end

    it 'has a 401 response' do
      expect(response).to have_http_status 401
    end

    it 'journalist cannot see unpublished articles' do
      expect(response_json['message']).to eq 'You are not authorized'
    end
  end

  describe 'GET /api/admin/articles unauthorized' do
    before do
      get '/api/admin/articles'
    end

    it 'has a 401 response' do
      expect(response).to have_http_status 401
    end

    it 'visitor cannot see unpublished articles' do
      expect(response_json['errors'][0]).to eq "You need to sign in or sign up before continuing."
    end
  end
end
