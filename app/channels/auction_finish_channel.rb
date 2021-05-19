class AuctionFinishChannel < ApplicationCable::Channel
  def subscribed
    stream_from "auction_finish_#{params[:timer_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
