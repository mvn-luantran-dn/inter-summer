namespace :show do
  desc 'Show detail auctions'
  task auction_detail: :environment do
    set_interval(1) do
      key_timer = $redis.keys('*')
      key_timer.each do |key|
        timer = JSON.load($redis.get(key))
        cat_timer = []
        key_timer.each do |timer_key|
          start_at = timer_key['start_at'].to_s.to_time.strftime("%H:%M:%S").to_time
          end_at = timer_key['end_at'].to_s.to_time.strftime("%H:%M:%S").to_time
          if Time.now > start_at && Time.now < end_at
            timer_check = JSON.load($redis.get(timer_key))
            cat_timer << timer_check if timer['product_category'] == timer_check['product_category'] && timer_check['id'] != timer['id'] && timer_check['status'] == 'on'
            break if cat_timer.size == 5
          end
        end
        ActionCable.server.broadcast("auction_detail_#{key}", obj: timer, cat: cat_timer)
      end
    end
  end
end

def set_interval(delay)
  mutex = Mutex.new
  Thread.new do
    mutex.synchronize do
      loop do
        sleep delay
        yield
      end
    end
  end
end
