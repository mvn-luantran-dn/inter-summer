class Admin::CategoriesController < Admin::BaseController
  before_action :root_categories, only: %i[new create]
  before_action :find_category, only: %i[show edit update]
  before_action :root_categories_without_self, only: %i[edit update]

  def index
    @categories_no_parent = Category.root
    @categories = if params[:content].blank?
                    Category.paginate(page: params[:page], per_page: 10).order('id DESC')
                  else
                    Category.search_name(params[:content])
                            .paginate(page: params[:page], per_page: 10)
                            .order('id DESC')
                  end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Add category success'
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
      flash[:success] = 'Update success'
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if check_delete_category @category
      @category.destroy!
      flash[:success] = 'Category deleted'
    else
      flash[:success] = 'Delete error'
    end
    redirect_to admin_categories_url
  end

  def import
    if params[:file].nil?
      flash[:notice] = 'Please choose file'
      render :show_import
    else
      if Category.import_file params[:file]
        flash[:notice] = 'Data imported'
      else
        flash[:danger] = 'Import error'
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
            redirect_to admin_categories_path, notice: 'Delete error'
          end
        end
        unless delete_ids.empty?
          delete_ids.each do |id|
            update_category_chid @category
          end
          redirect_to admin_categories_path, notice: 'Delete success'
        end
      end
    end
  end

  private

    def category_params
      params.require(:category).permit(:name, :parent_id)
    end

    def root_categories
      @categories = Category.root
    end

    def find_category
      @category = Category.find_by(id: params[:id])
      redirect_to '/404' unless @category
    end

    def root_categories_without_self
      id = @category.id
      @categories = Category.get_without_self(id).get_without_parent_self(id)
    end

    def check_delete_category(category)
      category.products.each do |product|
        return false unless product_can_delete product
      end
      check_delete_category category.child_categories if category.child_categories.any?
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
