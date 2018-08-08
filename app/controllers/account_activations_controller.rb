class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    debugger
    if user && !user.activated_at? && user.authenticated?(:activation, params[:id])
      user.activate
      # log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to '/'
    end
  end
end