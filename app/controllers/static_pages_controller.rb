class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: :show
  def home; end

  def show
    timer = Timer.find_by(id: params[:id])
    @product = timer.product
    auction = Auction.auction_timer(timer.id).last
    @auction_details = auction.auction_details.order('price_bid DESC')
  end
end
