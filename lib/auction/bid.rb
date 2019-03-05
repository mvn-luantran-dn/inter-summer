class Bid
  def self.bidding(data, key)
    timer = JSON.load($redis.get(key))
    auction = Auction.auction_timer(timer['id']).last
    return if auction.nil?

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
        auction_details = auction.auction_details.order('price_bid DESC')
        id_user_win_old = auction_details.first.user.id
        user = auction_details.find_by(user_id: user_id)
        if user
          auction.auction_details.create!(
            user_id: user_id,
            price_bid: data['price']
          )
        else
          user.update_attributes(price_bid: data['price'], created_at: DateTime.now)
        end
        name_user = User.find_by(id: user_id).name
        Notification.create!(
          content: "#{name_user} is bidding higher price at #{timer['product_name']}.Price now: #{data['price']}",
          user_id: id_user_win_old,
          status: 1,
          timer_id: key
        )
        notification = Notification.all.where(user_id: id_user_win_old).order('created_at DESC')
        ActionCable.server.broadcast("notification_#{id_user_win_old}", obj: notification)
        Bid.append_user_bid(key, auction)
        Bid.set_auction_countinue(timer, data, key)
      end
    end
  end

  def self.set_auction_countinue(timer, data, key)
    timer['product_price_start'] = data['price']
    timer['period'] = 20 if timer['period'] < 20
    $redis.set(key, timer.to_json)
  end

  def self.append_user_bid(key, auction)
    auction_details_arr = auction.auction_details.order('price_bid DESC')
    arr = []
    auction_details_arr.each do |obj|
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
