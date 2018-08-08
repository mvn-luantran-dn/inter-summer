# frozen_string_literal: true

class OmniauthsController < ApplicationController
  def create
    binding.pry
    @user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    session[:user_id] = @user.id
    flash[:success] = 'Login success'
    redirect_to root_path
  end
end
