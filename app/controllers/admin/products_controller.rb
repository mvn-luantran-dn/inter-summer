require 'csv'

class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i[show edit update destroy]
  before_action :load_categories, only: %i[new create edit update]

  def index
    respond_to do |format|
      format.html do
        if params[:content].blank?
          @products = Product.paginate(page: params[:page], per_page: 10).order('id DESC')
        else
          @products = Product.search_product(params[:content]).paginate(page: params[:page], per_page: 10).order('id DESC')
        end
      end

      format.csv do
        filename = "Product_#{Time.now.to_i}.csv"
        headers['Content-Disposition'] = "attachment; filename=#{filename}"
        headers['Content-Type'] ||= 'text/csv'
        @products = Product.all
      end
    end
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
    @product.status = ProductStatus::SELLING
    return redirect_to admin_products_url, notice: 'Add product success' if @product.save
    render :new
  end

  def edit; end

  def update
    if @product.update_attributes(product_params)
      @product.timers.each do |timer|
        AuctionData.update(timer) unless $redis.get(timer.id).nil? 
      end
      return redirect_to admin_products_path, notice: 'Update success'
    else  
      render :edit
    end
  end

  def destroy
    if product_can_delete @product
      @product.destroy
      flash[:success] = 'Delete product success'
    end
    redirect_to admin_products_url
  end
  
  def delete_more_product
    if request.post?
      delete_ids = params[:ids].collect {|id| id.to_i} if params[:ids]
      delete_ids.each do |id|
        Product.find(id).destroy
      end
    end
    redirect_to admin_products_url, notice: "Delete success"
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

    def product_can_delete product
      if product.timers.where(status: 'on').size > 0
        flash[:notice] = 'Please turn off all timer'
        return false
      else
        Item.where(product_id: product.id).each do |item|
          if item.order.status != 'received'
            flash[:notice] = 'Product in order. Please wait for chekout'
            return false  
          end
        end
      end
      true
    end
end
