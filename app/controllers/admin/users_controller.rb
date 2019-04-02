class Admin::UsersController < Admin::BaseController
  before_action :logged_in_user, only: %i[index edit update destroy block]
  before_action :find_user, only: %i[show edit update destroy block]
  before_action :admin_user, only: %i[destroy block]
  before_action :load_genders_user, only: %i[new create edit update]
  before_action :load_roles, only: %i[new create edit update]

  def index
    @users = User.include_basic.common_order
  end

  def show
    respond_to do |format|
      format.json do
        user = User.find_by(id: params[:id])
        avatar = user.asset
        render json: { user: user, asset: avatar }
      end
    end
  end

  def new
    @user = User.new
    @date_birth_day = Time.zone.today - 18.years
  end

  def create
    password = generate_password
    @user = User.new(user_params.merge(password: password))
    @user.activated_at = Time.zone.now
    @user.status = false
    if @user.save
      if params[:user][:file].present?
        Asset.create!(asset_params.merge(module_type: User.name, module_id: @user.id))
      end
      flash[:success] = I18n.t('users.create.success')
      send_mail_password(@user, password)
      redirect_to admin_users_path
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
      flash[:success] = I18n.t('users.update.success')
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.root && @user.role == 'admin'
      flash[:danger] = I18n.t('users.destroy.root')
    elsif @user.destroy
      flash[:success] = I18n.t('users.destroy.success')
    else
      flash[:danger] = I18n.t('users.destroy.error')
    end
    redirect_to admin_users_url
  end

  def block
    respond_to do |format|
      format.json do
        if @user.root && @user.role == 'admin'
          render json: { message: I18n.t('users.destroy.root') }
        elsif @user.deactivated_at.blank?
          if @user.update_attribute(:deactivated_at, Time.zone.now)
            UserMailer.block_account(@user, params[:reason]).deliver_later
            render json: { message: I18n.t('users.block.success') }
          else
            render json: { message: I18n.t('users.block.error') }
          end
        elsif @user.update_attribute(:deactivated_at, nil)
          UserMailer.open_account(@user, params[:reason]).deliver_later
          render json: { message: I18n.t('users.open.success') }
        else
          render json: { message: I18n.t('users.open.error') }
        end
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :role, :address, :phone, :birth_day, :gender)
    end

    def asset_params
      params.require(:user).permit(:file)
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

    def generate_password
      SecureRandom.urlsafe_base64(6)
    end

    def send_mail_password(user, password)
      UserMailer.create_account(user, password).deliver_later
    end

    def load_genders_user
      @genders = User.genders
    end

    def load_roles
      @roles = User.roles
    end
end
