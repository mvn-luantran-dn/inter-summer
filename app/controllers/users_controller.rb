class UsersController < ApplicationController
  before_action :find_user, only: %i[show edit update correct_user]
  before_action :logged_in_user, only: %i[index edit update]
  before_action :correct_user, only: %i[edit update]
  before_action :redirect_logined, only: :new

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = 'user'
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Update success'
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def id_current_user
    respond_to do |format|
      format.json { render json: current_user.id }
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_comfirm)
    end

    def find_user
      @user = User.find_by(id: params[:id])
      redirect_to '/404' unless @user
    end

    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
end
