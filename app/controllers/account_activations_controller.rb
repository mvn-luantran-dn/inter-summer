class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated_at? && user.authenticated?(:activation, params[:id])
      user.activate
      login user
      flash[:success] = 'Account activated!'
      redirect_to root_path
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
