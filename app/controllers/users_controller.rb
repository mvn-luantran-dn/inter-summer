class UsersController < ApplicationController
  before_action :find_user, only: %i[show edit update correct_user edit_pass update_pass]
  before_action :logged_in_user, only: %i[index edit update edit_pass update_pass]
  before_action :correct_user, only: %i[edit update edit_pass update_pass]
  before_action :redirect_logined, only: :new
  before_action :load_genders_user, only: %i[edit update]

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
      if params[:user][:file].present?
        @user.asset.destroy! if @user.asset.present?
        Asset.create!(asset_params.merge(module_type: User.name, module_id: @user.id))
      end
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

  def update_pass
    if @user.update_attributes(password_params)
      flash[:success] = 'Update success'
      redirect_to edit_password_path(@user)
    else
      render :edit_pass
    end
  end

  def my_orders
    @orders = current_user.orders.paginate(page: params[:page], per_page: 5).order('id ASC')
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :address, :phone,
                                   :gender, :birth_day, :password_comfirm, :password)
    end

    def asset_params
      params.require(:user).permit(:file)
    end

    def password_params
      params.require(:user).permit(:password, :password_comfirm)
    end

    def find_user
      @user = User.find_by(id: params[:id])
      redirect_to '/404' unless @user
    end

    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end

    def load_genders_user
      @genders = User.genders
    end
end
