class DbData
  def create_auction(timer)
    timer_id = timer['id']
    auction = Auction.all.auction_timer(timer_id)
    auction_size = auction.size
    if auction_size.positive?
      auction = auction.last
      if auction.status == Common::Const::AuctionStatus::FINISHED
        Auction.create!(timer_id: timer_id, status: Common::Const::AuctionStatus::RUNNING)
      end
    else
      Auction.create!(timer_id: timer_id, status: Common::Const::AuctionStatus::RUNNING)
    end
  end

  def close_auction(timer)
    timer_id = timer['id']
    auction = Auction.auction_timer(timer_id)
    auction = auction.last
    auction.update_attribute(:status, Common::Const::AuctionStatus::FINISHED)
  end

  def user_win(timer)
    timer_id = timer['id']
    auction = Auction.auction_timer(timer_id)
    auction = auction.last
    product = auction.timer.product
    auction_dls = auction.auction_details.last
    unless auction_dls.nil?
      sub_quantity(product, timer)
      create_order(product, auction_dls)
      ActionCable.server.broadcast("auction_finish_#{timer_id}", obj: auction_dls.user_id)
    end
  end

  def sub_quantity(product, timer)
    quantity = product.quantity
    product.update_attribute(:quantity, quantity - 1)
    timer['product_quantity'] = timer['product_quantity'] - 1
    $redis.set(timer['id'], timer.to_json)
  end

  def create_order(product, auction_dls)
    order = Order.find_by(user_id: auction_dls.user_id, status: 'wait')
    if order.nil?
      order = Order.new
      order.user_id = auction_dls.user_id
      order.status = 'wait'
      order.total_price = auction_dls.price_bid
      order.name = auction_dls.user.name
      order.save
    else
      total_price = order.total_price + auction_dls.price_bid.to_i
      order.update_attribute(:total_price, total_price)
    end
    create_item(order, product, auction_dls)
  end

  def create_item(order, product, auction_dls)
    order.items.create!(
      product_id: product.id,
      amount: auction_dls.price_bid
    )
  end

  def del_auction_no_bid(auction)
    auction.destroy unless auction.auction_details.any?
  end
end
