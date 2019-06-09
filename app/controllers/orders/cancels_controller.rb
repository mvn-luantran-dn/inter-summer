class Orders::CancelsController < ApplicationController
  def update
    order = Order.find(params[:id])
    order.cancel_action
    flash[:success] = 'Cancel success'
    redirect_to my_orders_path(current_user)
  end
end
