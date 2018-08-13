class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      flash[:success] = 'Login success'
      login(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember(user)
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
