class Admin::PromotionsController < Admin::BaseController
  before_action :find_promotion, only: %i[edit update destroy]
  before_action :load_categories, only: %i[new create edit update]
  before_action :detail_promotion, only: :show

  def index
    respond_to do |format|
      format.html do
        @promotions = Promotion.common_order
      end
    end
  end

  def new
    @promotion = Promotion.new
    @promotion.promotions_categories.build
  end

  def show
    @promotions_categories = @promotion.promotions_categories
  end

  def create
    @promotion = Promotion.new(promotion_params)
    @promotion.user_id = @current_user.id
    if @promotion.save
      if params[:promotion][:file].present?
        Asset.create!(asset_params.merge(module_type: Promotion.name, module_id: @promotion.id))
      end
      flash[:success] = I18n.t('promotions.create.success')
      redirect_to admin_promotions_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @promotion.update_attributes(promotion_params)
      if params[:promotion][:file].present?
        @promotion.asset.destroy! if @promotion.asset.present?
        Asset.create!(asset_params.merge(module_type: Promotion.name, module_id: @promotion.id))
      end
      flash[:success] = I18n.t('promotions.update.success')
      redirect_to admin_promotions_path
    else
      render :edit
    end
  end

  def destroy
    if @promotion.destroy!
      flash[:success] = I18n.t('promotions.destroy.success')
    else
      flash[:danger] = I18n.t('promotions.destroy.error')
    end
    redirect_to admin_promotions_path
  end

  def category_pro
    respond_to do |format|
      format.json do
        arr_id = params[:arr_id].split(',');
        @categories = Category.where.not(id: arr_id)
        render json: @categories
      end
    end
  end

  private

    def promotion_params
      params.require(:promotion).permit(
        :name, :start_date, :end_date, :detail, :description,
        promotions_categories_attributes: %i[id category_id discount _destroy]
      )
    end

    def asset_params
      params.require(:promotion).permit(:file)
    end

    def find_promotion
      @promotion = Promotion.find_by(id: params[:id]) || redirect_to_not_found
    end

    def load_categories
      @categories = Category.all
    end

    def detail_promotion
      return @promotion if @promotion

      @promotion = Promotion.includes(:promotions_categories).find_by(id: params[:id]) ||
                   redirect_to_not_found
    end
end
