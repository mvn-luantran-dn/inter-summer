class Orders::CancelsController < ApplicationController
  def update
    order = Order.find(params[:id])
    order.update_columns(status: Order::STATUS_CANCLED)
    flash[:success] = 'Cancel success'
    redirect_to my_orders_path(current_user)
  end
end
