class AuctionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'auctions'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
