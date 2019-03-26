class Admin::PromotionsCategoriesController < Admin::BaseController
  before_action :find_promotion
  before_action :find_pro_cat, only: %i[edit update destroy load_categories]
  before_action :load_categories, only: %i[new create edit update]

  def index
    @promotions_categories = @promotion.promotions_categories
                                       .paginate(page: params[:page], per_page: 10)
                                       .common_order
  end

  def new
    @pro_cat = @promotion.promotions_categories.build
  end

  def create
    @pro_cat = PromotionsCategory.new(pro_cat_params.merge(promotion_id: @promotion.id))
    if @pro_cat.save
      flash[:success] = I18n.t('promotions_categories.create.success')
      return redirect_to admin_promotion_promotions_categories_path
    else
      render :new
    end
  end

  def update
    if @pro_cat.update_attributes(pro_cat_params)
      flash[:success] = I18n.t('promotions_categories.update.success')
      return redirect_to admin_promotion_promotions_categories_path
    end
    render :edit
  end

  def destroy
    if @pro_cat.destroy
      flash[:success] = I18n.t('promotions_categories.destroy.success')
    else
      flash[:danger] = I18n.t('promotions_categories.check.timers')
    end
    redirect_to admin_promotion_promotions_categories_path
  end

  private

    def pro_cat_params
      params.require(:promotions_category).permit(%i[category_id discount])
    end

    def find_promotion
      @promotion = Promotion.find_by(id: params[:promotion_id]) || redirect_to_not_found
    end

    def find_pro_cat
      @pro_cat = PromotionsCategory.find_by(id: params[:id]) || redirect_to_not_found
    end

    def load_categories
      @categories = Category.all - @promotion&.categories.to_a + [@pro_cat&.category]
      @categories = @categories.compact
    end
end
