class Admin::AuctionsController < Admin::BaseController
  before_action :find_auction, only: :destroy
  before_action :auction_details, only: :show
  before_action :list_status, only: :index

  def index
    if params[:content].present? && params[:"time-start"].present? &&
       params[:"time-end"].present? && params[:"date-start"].present? &&
       params[:"date-end"].present?
      content = params[:content]
      time_start = params[:"time-start"]
      time_end = params[:"time-end"]
      date_start = params[:"date-start"].to_time
      date_end = params[:"date-end"].to_time
      start_time = convert_time(time_start, date_start)
      end_time = convert_time(time_end, date_end)
      @auctions = Auction.search(content, start_time, end_time)
                         .paginate(page: params[:page], per_page: 10)
                         .common_order
    else
      @auctions = Auction.includes(:auction_details)
                         .common_order
    end
  end

  def show
    respond_to do |format|
      format.json do
        auction = Auction.includes(auction_details: [user: :asset], timer: [product: :assets])
                         .find_by(id: params[:id])
        render json: auction, serializer: Auctions::ShowSerializer
      end
    end
  end

  def destroy
    if check_delete_auction @auction
      @auction.destroy
      flash[:success] = I18n.t('actions.destroy.success')
    else
      flash[:danger] = I18n.t('actions.destroy.alert')
    end
    redirect_to admin_auctions_path
  end

  def delete_more_auction
    return unless request.post? || params[:ids]

    delete_ids = []
    params[:ids].each do |id|
      if check_delete_auction Auction.find(id.to_i)
        delete_ids << id.to_i
      else
        flash[:danger] = I18n.t('actions.destroy.alert')
        return redirect_to admin_auctions_path
      end
    end
    unless delete_ids.empty?
      Auction.where(delete_ids).delete_all
      flash[:success] = I18n.t('actions.destroy.success')
      redirect_to admin_auctions_path
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
      auction.status == Common::Const::AuctionStatus::FINISHED
    end

    def auction_details
      @auction = Auction.find_by(id: params[:id]) || redirect_to_not_found
    end

    def list_status
      @list_status = Common::Const::AuctionStatus::STATUS.map { |st| st.upcase }
    end
end
