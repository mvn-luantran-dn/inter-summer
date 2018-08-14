class Admin::AuctionsController < Admin::BaseController
  before_action :find_auction, only: %i[show edit update destroy]

  def index
    @auctions = Auction.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

  def show
    @auction_details = @auction.auction_details.paginate(page: params[:page], per_page: 20)
  end

  def update
    if @auction.update_attributes(auction_params)
      flash[:success] = 'Update success'
      redirect_to admin_auctions_path
    else
      render :edit
    end
  end

  def destroy
    @auction.destroy
    flash[:success] = 'Auction deleted'
    redirect_to admin_auctions_path
  end

  private

    def find_auction
      @auction = Auction.find_by(id: params[:id]) or not_found
    end

    def auction_params
      params.require(:auction).permit(%i(product_id start_at period bid_step))
    end
end
