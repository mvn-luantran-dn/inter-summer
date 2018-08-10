module Admin::AuctionsHelper

  def current_auction?(auction)
    auction == current_auction
  end

end
