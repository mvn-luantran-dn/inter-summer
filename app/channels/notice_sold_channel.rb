class NoticeSoldChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notice_sold_#{params[:timer_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
