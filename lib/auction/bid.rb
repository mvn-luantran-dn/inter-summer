class Bid
  def self.bidding(data, key)
    timer = JSON.load($redis.get(key))
    auction = Auction.auction_timer(timer['id']).last
    unless auction.nil?
      auction_details = auction.auction_details.order('price_bid DESC').first
      user_id = data['user_id'].to_i
      if auction_details.nil?
        auction.auction_details.create!(
          user_id: user_id,
          price_bid: data['price']
        )
        Bid.append_user_bid(key, auction)
        Bid.set_auction_countinue(timer, data, key)
      else
        if auction_details.user_id == user_id
          obj = {
            user_id: user_id,
            price_bid: auction_details.price_bid
          }
          ActionCable.server.broadcast("message_#{key}", obj: obj)
        else
          auction_details = auction.auction_details
          user = auction_details.find_by(user_id: user_id)
          if user.nil?
            auction.auction_details.create!(
              user_id: user_id,
              price_bid: data['price']
            )
          else
            user.update_attributes(price_bid: data['price'], created_at: DateTime.now)
          end
          Bid.append_user_bid(key, auction)
          Bid.set_auction_countinue(timer, data, key)
        end
      end
    end
  end

  def self.set_auction_countinue(timer, data, key)
    timer['product_price_start'] = data['price']
    timer['period'] = 20 if timer['period'] < 20
    $redis.set(key, timer.to_json)
  end

  def self.append_user_bid(key, auction)
    auction_details = auction.auction_details.order('price_bid DESC')
    arr = []
    auction_details.each do |obj|
      hash_tmp = {
        name: obj.user.name,
        price_bid: obj.price_bid,
        created_at: obj.created_at
      }
      arr << hash_tmp
    end
    ActionCable.server.broadcast("bid_#{key}", obj: arr)
  end
end
