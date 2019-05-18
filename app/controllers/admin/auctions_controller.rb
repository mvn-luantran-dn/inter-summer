class Admin::AuctionsController < Admin::BaseController
  before_action :find_auction, only: :destroy
  before_action :auction_details, only: :show
  before_action :list_status, only: :index

  def index
    format_params
    @auctions = Auction.includes(auction_details: :user, timer: [product: :assets])
                       .common_order
    if params[:start_time] && params[:end_time]
      @auctions.select do |auction|
        auction.created_at.between?(params[:start_time], params[:end_time])
      end
    end
    return @auctions unless params[:status]

    @auctions.select { |auction| auction.status == params[:status] }
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

    def format_params
      params[:start_time] = params[:start_time]&.to_time
      params[:end_time] = params[:end_time]&.to_time
      params[:status] = params[:status]&.downcase
    end
end
