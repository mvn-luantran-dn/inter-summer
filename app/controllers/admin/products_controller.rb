class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i[show edit update destroy]
  before_action :load_categories, only: %i[new create edit update]

  def index
    @products = Product.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

  def new
    @product = Product.new
    @product.assets.build
  end

  def show
    @assets = @product.assets
  end

  def create
    @product = Product.new(product_params)
    @product.status = 'selling'
    if @product.save
      flash[:success] = 'Add product success'
      redirect_to admin_products_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update_attributes(product_params)
      flash[:success] = 'Update success'
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:success] = 'Product deleted'
    redirect_to admin_products_url
  end

  private

    def product_params
      params.require(:product).permit(:name, :category_id, :detail, :price,
                                      :price_at, :quantity, assets_attributes:
                                      %i[id file_name _destroy])
    end

    def find_product
      @product = Product.find_by(id: params[:id])
      redirect_to '/404' unless @product
    end

    def load_categories
      @categories = Category.all
    end
end
