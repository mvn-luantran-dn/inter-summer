require 'csv'

class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i[edit update destroy]
  before_action :load_categories, only: %i[new create edit update]
  before_action :detail_product, only: :show

  def index
    respond_to do |format|
      format.html do
        @products = if params[:content].blank?
                      Product.paginate(page: params[:page], per_page: 10)
                             .common_order
                    else
                      Product.search_product(params[:content])
                             .paginate(page: params[:page], per_page: 10)
                             .common_order
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
    binding.pry
    if @product.save
      flash[:success] = I18n.t('products.create.success')
      redirect_to admin_products_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if product_can_update @product
      if @product.update_attributes(product_params)
        @product.timers.each do |timer|
          AuctionData.update(timer) unless $redis.get(timer.id).nil?
        end
        flash[:success] = I18n.t('products.update.success')
        redirect_to admin_products_path
      else
        render :edit
      end
    else
      redirect_to admin_products_path
    end
  end

  def destroy
    if product_can_delete @product
      flash[:success] = I18n.t('products.destroy.success')
    else
      flash[:danger] = I18n.t('products.destroy.error')
    end
    redirect_to admin_products_url
  end

  def delete_more_product
    return unless request.post? || params[:ids]

    delete_ids = []
    params[:ids].each do |id|
      if product_can_delete Product.find(id.to_i)
        delete_ids << id.to_i
      else
        redirect_to admin_products_url
      end
    end
    return if delete_ids.empty?

    Product.where(delete_ids).delete_all
    flash[:success] = I18n.t('products.destroy.success')
    redirect_to admin_products_url
  end

  private

    def product_params
      params.require(:product).permit(:name, :category_id, :detail, :price,
                                      :price_at, :quantity, assets_attributes:
                                      %i[id file _destroy])
    end

    def find_product
      @product = Product.find_by(id: params[:id]) || redirect_to_not_found
    end

    def load_categories
      @categories = Category.all
    end

    def product_can_delete(product)
      if !product.timers.where(status: 'on').empty?
        flash[:notice] = I18n.t('products.check.timer')
        return false
      else
        Item.where(product_id: product.id).each do |item|
          if item.order.status != 'received'
            flash[:notice] = I18n.t('products.check.order')
            return false
          end
        end
      end
      true
    end

    def product_can_update(product)
      unless product.timers.where(status: 'on').empty?
        flash[:notice] = I18n.t('products.check.timer')
        return false
      end
      true
    end

    def detail_product
      return @product if @product

      @product = Product.includes(:assets).find_by(id: params[:id]) || redirect_to_not_found
    end
end
