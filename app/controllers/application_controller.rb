class ApplicationController < ActionController::Base
  include SessionsHelper
  include UsersHelper

  def redirect_to_not_found
    raise ActionController::RoutingError, 'Not Found'
  rescue StandardError
    redirect_to not_found_path
  end

  def page_not_found
    render(status: 404)
  end
end
