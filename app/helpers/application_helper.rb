module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Autions'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def size_cart
    return unless logged_in?
    if Order.find_by(user_id: current_user.id)
      @size_cart = Order.find_by(user_id: current_user.id).items.size
    end
  end
end
