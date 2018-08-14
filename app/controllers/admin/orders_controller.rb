class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i[show destroy]

  def index
    @orders = Order.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

  def show
    @items = @order.items.paginate(page: params[:page], per_page: 20)
  end

  private

    def find_order
      @order = Order.find_by(id: params[:id])  or not_found
    end
end
