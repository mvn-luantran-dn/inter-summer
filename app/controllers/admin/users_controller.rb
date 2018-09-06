class Admin::UsersController < Admin::BaseController
  before_action :logged_in_user, only: %i[index edit update destroy block]
  before_action :find_user, only: %i[show edit update destroy block]
  before_action :admin_user, only: %i[destroy block]

  def index
    if params[:content].blank?
      @users = User.paginate(page: params[:page], per_page: 10).order('id DESC')
    else
      @users = User.search_name_email(params[:content]).paginate(page: params[:page], per_page: 10).order('id DESC')
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.status = 'on'
    @user.activated_at = Time.zone.now
    byebug
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
    else
      @user.destroy
      flash[:success] = 'User deleted'
    end
    redirect_to admin_users_url
  end

  def block
    if @user.name == 'admin'
      flash[:danger] = 'Admin root'
    else
      if @user.status == 'on'
        if @user.update_attribute(:status, 'off')
          flash[:success] = 'User blocked'
        else
          flash[:notice] = 'Block user error'
        end
      else
        if @user.update_attribute(:status, 'on')
          flash[:success] = 'User opened'
        else
          flash[:notice] = 'Block user error'
        end
      end
    end
    redirect_to admin_users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
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
