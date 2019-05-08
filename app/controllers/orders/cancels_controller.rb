class Orders::CancelsController < ApplicationController
  def update
    order = Order.find(params[:id])
    order.cancel_action
  end
end
