class Admin::BaseController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  include Common::Const

  layout 'admin/application'

  def index
    @products = Product.all.size
    @users = User.all.size
    @orders = Order.all.size
    @auctions = Auction.all.size
  end

  def report
    respond_to do |format|
      format.json do
        render json: statictis, serializer: Orders::ReportSerializer
      end
    end
  end

  private

    def statictis
      orders = Order.all.group_by { |order| order.updated_at.to_date }
      return orders if orders.size <= 6

      orders.drop(orders.size - 6)
    end
end
