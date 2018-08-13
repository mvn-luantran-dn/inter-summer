class Admin::CategoriesController < Admin::BaseController
  before_action :load_categories, only: %i[new create]
  before_action :find_category, except: %i[index new create]
  before_action :all_categories_without_self, only: %i[edit update]

  def index
    @categories_no_parent = Category.where(parent_id: nil)
    @categories = Category.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

  def new
    @parent_id = params[:format] unless params[:format].nil?
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
    @category.destroy
    flash[:success] = 'Category deleted'
    redirect_to admin_categories_url
  end

  private

    def category_params
      params.require(:category).permit(:name, :parent_id)
    end

    def load_categories
      @categories = Category.all
    end

    def find_category
      @category = Category.find_by(id: params[:id])
      redirect_to '/404' unless @category
    end

    def all_categories_without_self
      @categories = Category.get_without_self(@category.id).get_without_parent_self(@category.id)
    end
end
