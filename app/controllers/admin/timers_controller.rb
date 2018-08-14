class Admin::TimersController < Admin::BaseController
  before_action :find_product, only: %i(show new create)
  
  def index
  end
  
  def show
  end
  
  def new
    @timer = @product.timers.build
  end

  def create
    @timer = @product.timers.new(timer_params)
    if @timer.save 
      redirect_to admin_products_url
    else
      render :new
    end
  end
  
  def edit
  end

  def update
  end

  private
    def timer_params
      params.require(:timer).permit(%i(start_at end_at period status bid_step))
    end
    
    def find_product
      @product = Product.find_by(id: params[:product_id]) || redirect_to_not_found
    end
end
