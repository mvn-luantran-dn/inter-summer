module Admin::AuctionsHelper
  def current_auction?(auction)
    auction == current_auction
  end

  def money(auctions)
    total = 0
    auctions.each do |auction|
      next unless auction.status == Common::Const::AuctionStatus::FINISHED

      price_bid = auction.auction_details.order('price_bid DESC').first.price_bid
      price = auction.timer.product.price
      total += (price_bid - price)
    end
    total
  end
end
