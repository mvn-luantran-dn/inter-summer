class AuctionDetails::ShowSerializer < ApplicationSerializer
  attributes %i[price_bid updated_at]

  belongs_to :user, serializer: Users::MetaSerializer

  def updated_at
    object.updated_at.strftime('%Y-%m-%d, %I:%M:%p')
  end

  def price_bid
    number_with_delimiter(object.price_bid, delimiter: ',') + ' VND'
  end
end
