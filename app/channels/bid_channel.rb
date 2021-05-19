class BidChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bid_#{params[:timer_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
