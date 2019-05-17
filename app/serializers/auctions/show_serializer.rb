class Auctions::ShowSerializer < ApplicationSerializer
  attr_reader :winner_auction

  attributes %i[product winner price_final status]

  has_many :auction_details, serializer: AuctionDetails::ShowSerializer

  def product
    Products::ShowSerializer.new(object.timer.product).as_json
  end

  def winner
    details = object.auction_details
    return if details.blank?

    @winner_auction = object.auction_details.max_by(&:price_bid)
    Users::MetaSerializer.new(@winner_auction.user)
  end

  def price_final
    return unless winner_auction

    number_with_delimiter(winner_auction.price_bid, delimiter: ',') + ' VND'
  end
end
