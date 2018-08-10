class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i[show edit update destroy]

  def index
  end

  def new
    @product = Product.new
    @product.assets.build
    @categories = Category.all
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = 'Add product success'
      redirect_to admin_products_url
    else
      render :new
    end
  end

  def edit
  end
  
  def update
  end

  def destroy
  end

  private

    def product_params
      params.require(:product).permit(:name, :category_id, :detail, :price,
                                      :start_at, :end_at, :period, :step,
                                      :status, :price_at, assets_attributes: :file_name)
    end
    
    def asset_params
      params.require(:product).permit(:file_name)
    end

    def find_product
      @product = Product.find_by(id: params[:id])
      redirect_to '/404' unless @user
    end

end
