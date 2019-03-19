namespace :show do
  desc 'Show detail auctions'
  task auction_detail: :environment do
    loop_interval(1) do
      key_timer = $redis.keys('*')
      key_timer.each do |key|
        timer = JSON.parse($redis.get(key))
        cat_timer = []
        key_timer.each do |timer_key|
          timer_check = JSON.parse($redis.get(timer_key))
          start_at = timer_check['start_at'].to_s.to_time.strftime('%H:%M:%S').to_time
          end_at = timer_check['end_at'].to_s.to_time.strftime('%H:%M:%S').to_time
          if Time.now > start_at && Time.now < end_at
            cat_timer << timer_check if timer['product_category'] == timer_check['product_category'] && timer_check['id'] != timer['id'] && timer_check['status'] == 'on'
          end
          break if cat_timer.size == 5
        end
        ActionCable.server.broadcast("auction_detail_#{key}", obj: timer, cat: cat_timer)
      end
    end
  end
end

def loop_interval(delay)
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
