class SessionsController < ApplicationController
  before_action :redirect_logined, only: :new

  def new; end

  def create
    user = User.with_deleted.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if !user.deleted_at
        flash[:success] = 'Login success'
        login(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        remember(user)
        update_status_user_first_login(user)
        redirect_to root_path
      else
        flash.now[:danger] = 'User block. Contact amdin open'
        render :new
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def update_status_user_first_login(user)
    user.update_attributes(status: true)
  end
end
