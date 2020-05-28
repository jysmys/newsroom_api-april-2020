# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'
  namespace :api do
    resources :articles, only: %i[index show create], constraints: { format: 'json' }
    resources :subscriptions, only: [:create], constraints: { format: 'json' }
  end
end
