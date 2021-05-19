require 'auction/bid'
class AuctionDetailChannel < ApplicationCable::Channel
  def subscribed
    stream_from "auction_detail_#{params[:timer_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    Bid.bidding(data, params[:timer_id])
  end
end