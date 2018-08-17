class OrdersController < ApplicationController
<<<<<<< HEAD
  def index
    @order = Order.find_by(user_id: current_user.id, status: 'wait')
    @items = @order.items
  end

  def destroy
    @item = Item.find_by(id: params[:id])
    @item.destroy
    redirect_to user_orders_path
  end
=======
  def show; end

  def index; end
>>>>>>> master
end
