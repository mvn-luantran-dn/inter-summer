class Admin::TimersController < Admin::BaseController
  before_action :find_product
  before_action :find_timer, only: %i(edit update destroy)
  
  def index
    @timers = @product.timers
  end
  
  def new
    @timer = @product.timers.build
  end

  def create
    @timer = @product.timers.new(timer_params)
    return redirect_to(admin_product_timers_path) if @timer.save
    render :new
  end
  
  def update
    return redirect_to admin_product_timers_path, notice: 'Update success' if @timer.update_attributes(timer_params)
    render :edit
  end

  def destroy
    return redirect_to admin_product_timers_path, notice: 'Delete timer success' if  @timer.destroy
    flash[:alert] =  'Delete error'
  end

  private

    def timer_params
      params.require(:timer).permit(%i[start_at end_at period status bid_step])
    end

    def find_product
      @product = Product.find_by(id: params[:product_id]) || redirect_to_not_found
    end

    def find_timer
      @timer = Timer.find_by(id: params[:id]) || redirect_to_not_found
    end
end
