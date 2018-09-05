require 'datas/auction_data'

class Admin::TimersController < Admin::BaseController
  before_action :find_product
  before_action :find_timer, only: %i[edit update destroy]

  def index
    @timers = @product.timers.paginate(page: params[:page], per_page: 10).order('id DESC')
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
    if check_delete_timer @timer
      flash[:notice] = 'Delete timer success' if @timer.destroy
    else
      flash[:alert] = 'Timer off before delete'
    end
    redirect_to admin_product_timers_path
  end

  def delete_more_timer
    if request.post?
      if params[:ids]
        delete_ids = []
        params[:ids].each do |id|
          if check_delete_timer Timer.find(id.to_i)
            delete_ids << id.to_i
          else
            return redirect_to admin_product_timers_path, notice: 'Please turn off all timer'
          end
        end
        unless delete_ids.empty?
          delete_ids.each do |id|
            Timer.find(id).destroy
          end
          redirect_to admin_product_timers_path, notice: 'Delete success'
        end
      end
    end
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
          auction = timer.auctions.last
          if auction.status == 'run'
            auction.destroy
          end
          $redis.del(timer.id)
        else
          AuctionData.update(timer)
        end
      else
        AuctionData.add(timer) if timer_params['status'] == 'on'
      end
    end

    def check_delete_timer(timer)
      return true if timer.status == 'off'
      false
    end
end
