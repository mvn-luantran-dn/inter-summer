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
    @product.status = SELL
    return redirect_to admin_products_url, notice: 'Add product success' if @product.save
    render :new
  end

  def edit; end

  def update
    return redirect_to admin_products_path, notice: 'Update success' if @product.update_attributes(product_params)
    render :edit
  end

  def destroy
    @product.destroy
    redirect_to admin_products_url, notice: 'Product deleted'
  end

  private

    def product_params
      params.require(:product).permit(:name, :category_id, :detail, :price,
                                      :price_at, :quantity, assets_attributes:
                                      %i[id file_name _destroy])
    end

    def find_product
      @product = Product.find_by(id: params[:id]) || redirect_to_not_found
    end

    def load_categories
      @categories = Category.all
    end
end
