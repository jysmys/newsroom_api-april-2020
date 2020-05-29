# frozen_string_literal: true

RSpec.describe 'POST /api/auth/sign_in', type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }
  let(:user) { create(:user) }
  let(:expected_response) do
    {
      'data' => {
        'id' => user.id, 'uid' => user.uid, 'email'=> user.email,
        'provider' => 'email', 'role' => 'user', 'allow_password_change' => false
      }
    }
  end
  
  describe 'with valid credentials' do
    before do
      post '/api/auth/sign_in',
        params: {
          email: user.uid,
          password: user.password
        },
        headers: headers
    end

    it 'returns 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'returns the expected response' do
      expect(response_json).to eq expected_response
    end
  end

  describe 'with invalid password' do
    before do
      post '/api/auth/sign_in',
        params: {
          email: user.uid,
          password: 'wrong_password'
        },
        headers: headers
    end

    it 'returns 401 response status' do
      expect(response).to have_http_status 401
    end

    it 'returns error message' do
      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
    end
  end

  describe 'with invalid email' do
    before do
      post '/api/auth/sign_in',
        params: {
          email: 'wrong@email.com',
          password: user.password
        },
        headers: headers
    end

    it 'returns 401 response status' do
      expect(response).to have_http_status 401
    end

    it 'returns error message' do
      expect(response_json['errors']).to eq ['Invalid login credentials. Please try again.']
    end
  end
end
