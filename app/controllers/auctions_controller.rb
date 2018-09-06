class AuctionsController < ApplicationController
  before_action :find_auction, :load_active_bids, :correct_user
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
      @order = Order.where('user_id = ? and status != ?', current_user.id, 'wait').order('created_at DESC')              
    end

    def current_user?(user)
      user == current_user
    end
    
    def correct_user
      @user = User.find_by(id: params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
