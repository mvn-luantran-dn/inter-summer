namespace :show do
  desc 'Show detail auctions'
  task auction_detail: :environment do
    set_interval(1) do
      key_timer = $redis.keys('*')
      key_timer.each do |key|
        timer = JSON.load($redis.get(key))
        cat_timer = []
        key_timer.each do |timer_key|
          timer_check = JSON.load($redis.get(timer_key))
          cat_timer << timer_check if timer['product_category'] == timer_check['product_category'] && timer_check['id'] != timer['id']
          break if cat_timer.size == 5
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
