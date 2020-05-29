# frozen_string_literal: true

class Api::Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :editor?

  def index
      article = Article.where(published: false)
      render json: article, each_serializer: Admin::Article::IndexSerializer
  end

  private

  def editor?
    unless current_user.role == 'editor'
      render json: { message: 'You are not authorized', errors: ['You are not authorized'] }, status: 401
    end
  end
end