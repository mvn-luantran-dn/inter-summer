namespace :show do
  desc 'Show detail auctions'
  task auction_detail: :environment do
    set_interval(1) do
      key_timer = $redis.keys('*')
      key_timer.each do |key|
        timer = JSON.load($redis.get(key))
        ActionCable.server.broadcast("auction_detail_#{key}", obj: timer)
      end
    end
  end
end
