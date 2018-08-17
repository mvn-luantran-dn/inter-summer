module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Autions'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def set_interval(delay)
    mutex = Mutex.new
    Thread.new do
      mutex.synchronize do
        Rails.application.executor.wrap do
          loop do
            sleep delay
            yield
          end
        end
      end
    end
  end
end
