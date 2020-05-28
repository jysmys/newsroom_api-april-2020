class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  def create
    current_user.update_attribute(:subscriber, true)
    render json: { message: "Transaction was successful" }
  end
end
