require 'stripe_mock'

describe 'POST /api/subscriptions', type: :request do
  let(:user) {create(:user)}
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { {HTTP_ACCEPT: 'application/json' }.merge!(credentials)}
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:valid_token) { stripe_helper.generate_card_token }
  before(:each) { StripeMock.start }
  before(:each) { StripeMock.stop }
  let!(:product) { stripe_helper.create_product }
  let(:plan) do
    stripe_helper.create_plan(
      id: 'dns_subscription',
      amount: 50000,
      currency: 'usd',
      interval: 'month',
      interval_count: 12,
      name: 'DNS Subscription',
      product: product.id
    )
  end

    describe 'with valid parameters' do
      before do
        post '/api/subscriptions',
          params: {
            stripeToken: valid_token
          },
          headers: headers
      end

      it 'set the subscriber attribute to true on successful transaction' do
        user.reload
        expect(user.subscriber).to eq true
      end

      it 'returns sucess http code' do
        expect(response).to have_http_status 200
      end

      it 'returns sucess message' do
        expect(response_json['message']).to eq 'Transaction was sucessful'
      end
    end

    describe 'with invalid parameters' do
      before do
        post '/api/subscriptions', headers: headers
      end

      it 'returns error message' do
        expect(response_json['message']).to eq 'Transaction was NOT sucessful. There was no token provided...'
      end

      it 'returns error http code' do
        expect(response).to have_http_status 422
      end

      it 'does not set the subscriber attribute to true' do
        user.reload
        expect(user.subscriber).not_to eq true
      end
    end

end