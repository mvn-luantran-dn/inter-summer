module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Autions'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def format_time_to_seconds(time)
    time = time.strftime('%H:%M:%S').split(':')
    time[0].to_i * 3600 + time[1].to_i * 60 + time[2].to_i
  end

  def size_cart
    return unless logged_in?

    order = Order.find_by(user_id: current_user.id, status: 'wait')
    order&.items&.size
  end

  def redirect_logined
    redirect_to root_path if logged_in?
  end
end
