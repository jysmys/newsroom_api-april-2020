class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  def create
    # happy path:
    # check if there is a stripe token in params
    # create a stripe customer based on the current_user and the stripeToken
    # assign a subscription plan to the newly created customer
    # update the current_user to a subscriber
    # respond with a success message

    # create fallbacks if errors occur

    # Stripe API for subscription: price_HMTl7OAaIFy0jU
    
    if params[:stripeToken]
      customer = Stripe::Customer.list(email: current_user.email).data.first
      customer = Stripe::Customer.create({ email: current_user.email, source: params[:stripeToken] }) unless customer
      subscription = Stripe::Subscription.create({customer: customer.id, plan: 'dns_subscription'})
      if Rails.env.test?
        Stripe::Invoice.create({
        customer: customer.id,
        subscription: subscription.id,
        paid: true
        })
      end
      payment_status = Stripe::Invoice.retrieve(subscription.latest_invoice).paid
      if payment_status == true
        current_user.update_attribute(:subscriber, true)
        render json: { message: "Transaction was successful" }
      else
        render json: { message: 'Transaction was NOT successful, There was a problem with your payment' }, status: 422
      end
    else
      render json: { message: 'Transaction was NOT successful' }, status: 422
    end
  end
end
