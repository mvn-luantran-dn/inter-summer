require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

class AuctionData
  def self.send_data_to_redis
    @auction = Timer.all.includes(:product)
    @auction.each do |obj|
      auction_id = $redis.get(obj.id)
      time = format_time_to_seconds(obj.period)
      data = {
        id: obj.id,
        start_at: obj.start_at,
        end_at: obj.end_at,
        period: time,
        bid_step: obj.bid_step,
        status: obj.status,
        product_id: obj.product_id,
        product_name: obj.product.name,
        product_price: obj.product.price,
        product_quantity: obj.product.quantity,
        product_pictures: obj.product.assets,
        product_detail: obj.product.detail,
        product_category: obj.product.category_id
      }
      $redis.set(obj.id, data.to_json) if auction_id.nil?
    end
  end

  def push_data(key, data)
    auction = JSON.parse($redis.get(key))
    if auction['status'] == 'on' && auction['product_quantity'].positive?
      decreasing_time(key)
      finish_auction(key)
      key = JSON.parse($redis.get(key))
      data << key
    end
  end

  def decreasing_time(key)
    auction = JSON.parse($redis.get(key))
    auction['period'] = auction['period'] - 1
    $redis.set(key, auction.to_json)
  end

  def finish_auction(key)
    auction = JSON.parse($redis.get(key))
    period = auction['period']
    reset_auction_price(auction) if period.negative?
  end

  def reset_auction_price(auction)
    auction['period'] = load_period_default(auction['id'])
    auction['product_price'] = load_price_default(auction['id'])
    $redis.set(auction['id'], auction.to_json)
  end

  def load_period_default(id)
    auction = Timer.find_by(id: id)
    format_time_to_seconds(auction.period)
  end

  def load_price_default(id)
    auction = Timer.find_by(id: id)
    auction.product.price
  end
end
