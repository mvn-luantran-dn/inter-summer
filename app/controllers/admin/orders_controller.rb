class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i[show edit update destroy]

  def index
    @orders = Order.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

  private
  def find_order
    @order = Order.find_by(id: params[:id])
    redirect_to '/404' unless @order
  end

end
