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
      flash[:success] = I18n.t('timers.create.success')
      return redirect_to(admin_product_timers_path)
    end
    render :new
  end

  def update
    if @timer.update_attributes(timer_params)
      update_timer(@timer)
      flash[:success] = I18n.t('timers.update.success')
      return redirect_to admin_product_timers_path
    end
    render :edit
  end

  def destroy
    if check_delete_timer @timer
      flash[:success] = I18n.t('timers.destroy.success') if @timer.destroy
    else
      flash[:alert] = I18n.t('timers.check.timers')
    end
    redirect_to admin_product_timers_path
  end

  def delete_more_timer
    return unless request.post? || params[:ids]

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
      redirect_to admin_product_timers_path, notice: I18n.t('timers.destroy.success')
    end
  end

  private

    def timer_params
      params.require(:timer).permit(%i[start_at end_at period is_running bid_step])
    end

    def find_product
      @product = Product.find_by(id: params[:product_id]) || redirect_to_not_found
    end

    def find_timer
      @timer = Timer.find_by(id: params[:id]) || redirect_to_not_found
    end

    def update_timer(timer)
      if $redis.get(timer.id)
        if timer_params['is_running']
          AuctionData.update(timer)
        else
          auction = timer.auctions.last
          auction.destroy if auction.status == Common::Const::AuctionStatus::RUNNING
          $redis.del(timer.id)
        end
      elsif timer_params['is_running']
        AuctionData.add(timer)
      end
    end

    def check_delete_timer(timer)
      timer.is_running == false
    end
end
