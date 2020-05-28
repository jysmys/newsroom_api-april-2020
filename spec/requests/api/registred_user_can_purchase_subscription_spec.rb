# rails g controller Api::Subscriptions create --skip-routes
# rails g migration add_subscriber_to_users subscriber:boolean

require 'stripe_mock'

describe "POST /api/subscriptions", type: :request do
  let(:user) {create(:user)}
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:stripe_helper) {StripeMock.create_test_helper}
  let(:valid_token) { stripe_helper.generate_card_token }

  before(:each) { StripeMock.start }
  after(:each) { StripeMock.stop }

  before '' do
    post '/api/subscriptions',
    params: {
      stipeToken: valid_token
    },
    headers: headers
  end

  it 'set the subscriber attribute to true on sucessfull transaction' do
    user.reload
    expect(user.subscriber).to eq true
  end

  it 'successful message' do
    expect(response_json['message']).to eq "Transaction was successful"
  end
end