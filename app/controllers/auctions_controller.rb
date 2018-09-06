class AuctionsController < ApplicationController
  before_action :find_auction, :load_active_bids
  def index; end
  
  private

    def find_auction
      @auction_details = AuctionDetail.where(user_id: current_user.id)
    end

    def load_active_bids
      @active = Auction.joins(:auction_details)
                       .where('auction_details.user_id = ?', current_user.id)
                       .where(status: 'run').order('created_at DESC')
      @finished = Auction.joins(:auction_details)
                         .where('auction_details.user_id = ?', current_user.id)
                         .where(status: 'finished').order('created_at DESC')
      @order = Order.where('user_id = ? and status != ?', current_user.id, 'wait')                   
    end
end
