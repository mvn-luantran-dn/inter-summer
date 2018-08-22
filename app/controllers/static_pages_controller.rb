class StaticPagesController < ApplicationController
  def home; end

  def show
    timer = Timer.find_by(id: params[:id])
    @product = timer.product
    auction = Auction.auction_timer(timer.id).last
    @auction_details = auction.auction_details
  end
end
