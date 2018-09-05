class Admin::AuctionsController < Admin::BaseController
  before_action :find_auction, only: %i[show edit update destroy]

  def index
    if params[:content].present? && params[:"time-start"].present? && params[:"time-end"].present? && params[:"date-start"].present? && params[:"date-end"].present?
      content = params[:content]
      time_start = params[:"time-start"]
      time_end = params[:"time-end"]
      date_start = params[:"date-start"].to_time
      date_end = params[:"date-end"].to_time
      start_time = convert_time(time_start, date_start)
      end_time = convert_time(time_end, date_end)
      @auctions = Auction.search(content, start_time, end_time).paginate(page: params[:page], per_page: 10).order('id DESC')
      byebug
    else
      @auctions = Auction.includes(:auction_details).paginate(page: params[:page], per_page: 10).order('id DESC')
    end
  end

  def show
    @auction_details = @auction.auction_details.paginate(page: params[:page], per_page: 20)
  end

  def destroy
    if check_delete_auction @auction
      @auction.destroy
      flash[:success] = 'Auction deleted'
      redirect_to admin_auctions_path
    else
      redirect_to admin_auctions_path, notice: 'Please wait auction finish'
    end
  end

  def delete_more_auction
    if request.post?
      if params[:ids]
        delete_ids = []
        params[:ids].each do |id|
          if check_delete_auction Auction.find(id.to_i)
            delete_ids << id.to_i
          else
            return redirect_to admin_auctions_path, notice: 'Please wait auction finish'
          end
        end
        unless delete_ids.empty?
          delete_ids.each do |id|
            Auction.find(id).destroy
          end
          redirect_to admin_auctions_path, notice: 'Delete success'
        end
      end
    end
  end

  private

    def find_auction
      @auction = Auction.find_by(id: params[:id]) || redirect_to_not_found
    end

    def auction_params
      params.require(:auction).permit(%i[product_id start_at period bid_step])
    end

    def convert_time(time, date)
      hour, min = time.split(':').map(&:to_i)
      date.change(hour: hour, min: min)
    end

    def check_delete_auction(auction)
      return true if auction.status == 'finished'
      false
    end
end
