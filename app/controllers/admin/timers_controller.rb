require 'datas/auction_data'

class Admin::TimersController < Admin::BaseController
  before_action :find_product
  before_action :find_timer, only: %i[edit update destroy]

  def index
    @timers = @product.timers.order('id DESC')
  end

  def new
    @timer = @product.timers.build
  end

  def create
    @timer = @product.timers.new(timer_params)
    if @timer.save
      AuctionData.add(@timer)
      return redirect_to(admin_product_timers_path)
    end
    render :new
  end

  def update
    if @timer.update_attributes(timer_params)
      update_timer(@timer)
      return redirect_to admin_product_timers_path, notice: 'Update success'
    end
    render :edit
  end

  def destroy
    if @timer.status == 'off'
      flash[:notice] = 'Delete timer success' if @timer.destroy
      flash[:alert] = 'Delete error'
    else
      flash[:alert] = 'Timer off before delete'
    end
    redirect_to admin_product_timers_path
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

    def update_timer(timer)
      if $redis.get(timer.id)
        if timer_params['status'] == 'off'
          $redis.del(timer.id)
        else
          AuctionData.update(timer)
        end
      else
        AuctionData.add(timer) if timer_params['status'] == 'on'
      end
    end
end
