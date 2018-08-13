class Admin::BaseController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  layout 'admin/application'

  def index; end
end
