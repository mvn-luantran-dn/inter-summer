class ApplicationController < ActionController::Base
  include SessionsHelper
  include UsersHelper
  
  def redirect_to_not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    redirect_to '/404'  
  end
end
