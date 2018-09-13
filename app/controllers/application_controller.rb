class ApplicationController < ActionController::Base
  include SessionsHelper
  include UsersHelper
  before_action :load_categories, :load_products, :load_notification

  def redirect_to_not_found
    raise ActionController::RoutingError, 'Not Found'
  rescue StandardError
    redirect_to not_found_path
  end

  def page_not_found
    render(status: 404)
  end

  def load_categories
    @categories = Category.where(parent_id: nil)
  end

  def load_products
    @products_footer = Product.order('created_at DESC').limit(3)
    @categories_footer = Category.where(parent_id: nil).limit(5)
  end

  def load_notification
    if logged_in?
      @notifications = Notification.where(user_id: current_user.id).order('created_at DESC')
      @quantity_notif = Notification.where(user_id: current_user.id, status: 1).size
    end
  end
end
