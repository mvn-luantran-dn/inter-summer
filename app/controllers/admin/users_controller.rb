# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :logged_in_user, only: %i[index edit update destroy]
  before_action :find_user, only: %i[show edit update destroy]
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

  def new
    @user = User.new
  end

  def create
    binding.pry
    @user = User.new(user_params)
    @user.activated_at = Time.zone.now
    if @user.save
      flash[:success] = 'Add user success'
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Update success'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.name == 'admin'
      flash[:danger] = 'Admin root'
      redirect_to admin_users_url
    else
      @user.destroy
      flash[:success] = 'User deleted'
      redirect_to admin_users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_comfirmation, :role)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  def find_user
    @user = User.find_by(id: params[:id])
    redirect_to '/404' unless @user
  end

  def admin_user
    redirect_to(admin_users_url) unless current_user.role == 'admin'
  end
end
