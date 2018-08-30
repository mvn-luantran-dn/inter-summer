class OrdersController < ApplicationController
  before_action :find_order, only: %i[index destroy edit update total_quantity]
  def index
    @items = @order.items if @order
  end

  def destroy
    item = Item.find_by(id: params[:id])
    total = @order.total_price - item.amount
    product = item.product
    product.timers.each do |timer|
      obj_timer = JSON.parse($redis.get(timer.id))
      obj_timer['product_quantity'] += 1
      $redis.set(timer.id, obj_timer.to_json)
    end
    quantity = product.quantity + 1
    product.update_attribute(:quantity, quantity)
    item.destroy
    @order.update_attribute(:total_price, total)
    @order.destroy unless @order.items.any?
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
      params.require(:order).permit(%i[name address phone type_payment])
    end

    def find_order
      @order = Order.find_by(user_id: current_user.id, status: 'wait')
    end
end
