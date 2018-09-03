class Admin::AuctionsController < Admin::BaseController
  before_action :find_auction, only: %i[show edit update destroy]

  def index
    if params[:content].blank?
      @auctions = Auction.includes(:auction_details).paginate(page: params[:page], per_page: 10).order('id DESC')
    else
      content = params[:content]
      time_start = params[:"time-start"]
      time_end = params[:"time-end"]
      date_start = params[:"date-start"].to_time
      date_end = params[:"date-end"].to_time
      start_time = convert_time(time_start, date_start)
      end_time = convert_time(time_end, date_end)
      @auctions = Auction.search(content, start_time, end_time).paginate(page: params[:page], per_page: 10).order('id DESC')
      byebug
    end
  end
  
  def show
    @auction_details = @auction.auction_details.paginate(page: params[:page], per_page: 20)
  end

  def destroy
    @auction.destroy
    flash[:success] = 'Auction deleted'
    redirect_to admin_auctions_path
  end

  private

    def find_auction
      @auction = Auction.find_by(id: params[:id]) || redirect_to_not_found
    end

    def auction_params
      params.require(:auction).permit(%i[product_id start_at period bid_step])
    end
    
    def convert_time(time, date)
      hour, min = time.split(":").map(&:to_i)
      date.change(hour: hour, min: min)
    end
end
