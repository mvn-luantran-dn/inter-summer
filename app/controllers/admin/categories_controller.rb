class Admin::CategoriesController < Admin::BaseController
  before_action :root_categories, only: %i[new create]
  before_action :find_category, only: %i[show edit update destroy]
  before_action :root_categories_without_self, only: %i[edit update]

  def index
    @categories = if params[:content].blank?
                    Category.include_basic.root
                            .paginate(page: params[:page], per_page: 10)
                            .common_order
                  else
                    Category.include_basic.root
                            .search_name(params[:content])
                            .paginate(page: params[:page], per_page: 10)
                            .common_order
                  end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      if params[:category][:file].present?
        Asset.create!(asset_params.merge(module_type: Category.name, module_id: @category.id))
      end
      flash[:success] = I18n.t('categories.create.success')
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
    @parent_id = @category.parent_id
  end

  def update
    if @category.update_attributes(category_params)
      if params[:category][:file].present?
        @category.asset.destroy! if @category.asset.present?
        Asset.create!(asset_params.merge(module_type: Category.name, module_id: @category.id))
      end
      flash[:success] = I18n.t('categories.update.success')
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if check_delete_category @category
      @category.destroy!
      flash[:success] = I18n.t('categories.destroy.success')
    else
      flash[:danger] = I18n.t('categories.destroy.error')
    end
    redirect_to admin_categories_url
  end

  def import
    if params[:file].nil?
      flash[:notice] = I18n.t('categories.import.notice')
      render :show_import
    else
      if Category.import_file params[:file]
        flash[:notice] = I18n.t('categories.import.success')
      else
        flash[:danger] = I18n.t('categories.import.error')
      end
      redirect_to admin_categories_path
    end
  end

  def delete_more_cat
    if request.post?
      if params[:ids]
        delete_ids = []
        params[:ids].each do |id|
          if check_delete_category Category.find(id.to_i)
            delete_ids << id.to_i
          else
            redirect_to admin_categories_path, notice: I18n.t('categories.destroy.error')
          end
        end
        unless delete_ids.empty?
          delete_ids.each do |id|
            update_category_chid @category
          end
          redirect_to admin_categories_path, notice: I18n.t('categories.destroy.success')
        end
      end
    end
  end

  private

    def category_params
      params.require(:category).permit(:name, :parent_id, :description)
    end

    def asset_params
      params.require(:category).permit(:file)
    end

    def root_categories
      @cat_list = Category.root
    end

    def find_category
      @category = Category.find_by(id: params[:id])
      redirect_to '/404' unless @category
    end

    def root_categories_without_self
      @cat_list = Category.root.get_without_self(@category.id)
    end

    def check_delete_category(category)
      category.products.each do |product|
        return false unless product_can_delete product
      end
      if category.child_categories.any?
        category.child_categories.each do |chid_cat|
          check_delete_category(chid_cat)
        end
      end
      true
    end

    def product_can_delete(product)
      return false unless product.timers.empty?

      Item.where(product_id: product.id).each do |item|
        return false if item.order.status != 'received'
      end
      true
    end
end
