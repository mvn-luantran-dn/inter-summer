class Admin::AuctionsController < Admin::BaseController
  before_action :find_auction, only: %i[show edit update destroy]

  def index
    @auctions = Auction.paginate(page: params[:page], per_page: 10).order('id DESC')
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
    @auction = Auction.find_by(id: params[:id])
    redirect_to '/404' unless @auction
  end
  
end

