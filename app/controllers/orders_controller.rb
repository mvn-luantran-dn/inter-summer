class OrdersController < ApplicationController
  before_action :find_order, only: %i[index destroy edit update total_quantity]

  def index
    @items = @order.items if @order
  end

  def destroy
    @item = Item.find_by(id: params[:id])
    @item.destroy
    redirect_to user_orders_path
  end

  def edit; end

  def update
    if @order.update_attributes(order_params)
      @order.update_attributes(status: 'checkouted')
      redirect_to root_path, notice: 'Success'
    else
      render :edit
    end
  end

  private

    def order_params
      params.require(:order).permit(%i[name address phone])
    end

    def find_order
      @order = Order.find_by(user_id: current_user.id, status: 'wait')
    end
end
