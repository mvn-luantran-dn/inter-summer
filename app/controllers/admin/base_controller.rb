class Admin::BaseController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  include Common::Const

  layout 'admin/application'

  def index
    @products = Product.where(status: 'selling').size
    @users = User.all.size
    @orders = Order.all.size
    @categories = Category.where(status: 'selling').size
  end
end
