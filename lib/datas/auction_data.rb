require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

require 'datas/db_data'
class AuctionData
  def self.send_data_to_redis
    @timer = Timer.all.includes(:product)
    @timer.each do |obj|
      timer_id = $redis.get(obj.id)
      time = format_time_to_seconds(obj.period)
      data = {
        id: obj.id,
        start_at: obj.start_at,
        end_at: obj.end_at,
        period: time,
        bid_step: obj.bid_step,
        status: obj.status,
        product_status: obj.product.status,
        product_id: obj.product_id,
        product_name: obj.product.name,
        product_price: obj.product.price,
        product_price_start: obj.product.price_at,
        product_quantity: obj.product.quantity,
        product_pictures: obj.product.assets,
        product_detail: obj.product.detail,
        product_category: obj.product.category_id
      }
      $redis.set(obj.id, data.to_json) if timer_id.nil?
    end
  end

  def push_data(key, data)
    db = DbData.new
    timer = JSON.parse($redis.get(key))
    if timer['product_status'] == 'selling'
      if timer['status'] == 'on'
        if timer['product_quantity'].positive?
          start_at = timer['start_at'].to_s.to_time.strftime('%H:%M:%S').to_time
          end_at = timer['end_at'].to_s.to_time.strftime('%H:%M:%S').to_time
          if Time.now > start_at && Time.now < end_at
            db.create_auction(timer)
            decreasing_time(key)
            finish_auction(key)
            key = JSON.parse($redis.get(key))
            data << key
          else
            auction = Auction.auction_timer(timer['id']).last
            unless auction.nil?
              if auction.status == 'run'
                decreasing_time(key)
                finish_auction(key)
                key = JSON.parse($redis.get(key))
                data << key
              end
            end
          end
        else
          timer_db = Timer.find_by(id: timer['id'])
          timer_db.update_attribute(:status, 'off')
          $redis.del(timer['id'])
          ActionCable.server.broadcast("notice_sold_#{timer_db.id}", obj: 'notice')
        end
      end
    else
      timer_db = Timer.find_by(id: timer['id'])
      timer_db.update_attribute(:status, 'off')
      $redis.del(timer['id']) unless timer.nil?
    end
  end

  def decreasing_time(key)
    timer = JSON.parse($redis.get(key))
    timer['period'] = timer['period'] - 1
    $redis.set(key, timer.to_json)
  end

  def finish_auction(key)
    timer = JSON.parse($redis.get(key))
    period = timer['period']
    if period.negative?
      submit(timer)
      reset_auction_price(timer)
    end
  end

  def reset_auction_price(timer)
    timer['period'] = load_period_default(timer['id'])
    timer['product_price_start'] = load_price_default(timer['id'])
    $redis.set(timer['id'], timer.to_json)
  end

  def load_period_default(id)
    timer = Timer.find_by(id: id)
    format_time_to_seconds(timer.period)
  end

  def load_price_default(id)
    timer = Timer.find_by(id: id)
    timer.product.price_at
  end

  def submit(timer)
    db_data = DbData.new
    db_data.close_auction(timer)
    db_data.user_win(timer)
    auction = Auction.auction_timer(timer['id']).last
    db_data.del_auction_no_bid(auction)
  end

  def self.add(obj)
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
      product_status: obj.product.status,
      product_price_start: obj.product.price_at,
      product_quantity: obj.product.quantity,
      product_pictures: obj.product.assets,
      product_detail: obj.product.detail,
      product_category: obj.product.category_id
    }
    $redis.set(obj.id, data.to_json)
  end

  def self.update(timer)
    data = JSON.parse($redis.get(timer.id))
    period = format_time_to_seconds(timer.period)
    data['start_at'] = timer.start_at
    data['end_at'] = timer.end_at
    data['bid_step'] = timer.bid_step
    data['product_id'] = timer.product_id
    data['product_name'] = timer.product.name
    data['product_price'] = timer.product.price
    data['product_detail'] = timer.product.detail
    data['product_price_start'] = timer.product.price_at
    data['product_quantity'] = timer.product.quantity
    data['product_pictures'] = timer.product.assets
    data['product_category'] = timer.product.category_id
    data['period'] = period
    data['status'] = timer.status
    $redis.set(timer.id, data.to_json)
  end

  def self.delete(obj)
    $redis.del(obj.id)
  end
end
