class OrdersController < ApplicationController
  before_action :find_order, only: %i[index edit update destroy]
  def index
    @items = @order.items if @order
  end

  def destroy
    item = Item.find_by(id: params[:id])
    total = @order.total_price - item.amount
    product = item.product
    if item.destroy
      product.timers.each do |timer|
        obj_timer = JSON.parse($redis.get(timer.id))
        obj_timer['product_quantity'] += 1
        $redis.set(timer.id, obj_timer.to_json)
      end
      quantity = product.quantity + 1
      product.update_attribute(:quantity, quantity)
      @order.update_attribute(:total_price, total)
      @order.destroy unless @order.items.any?
      flash[:success] = 'Delete success'
    else
      flash[:danger] = 'Delete error'
    end
    redirect_to user_orders_path
  end

  def edit; end

  def update
    if @order.update_attributes(order_params)
      total = @order.total_price + 29000
      @order.update_attributes(status: 'checkouted', total_price: total)
      flash[:success] = 'Success'
      redirect_to root_path
    else
      render :edit
    end
  end

  def cancel_order
    order_checkout = Order.find_by(id: params[:id])
    items = order_checkout.items
    if order_checkout.status == 'checkouted'
      if order_checkout.update_attributes(status: 'cancel')
        items.each do |item|
          product = item.product
          product.timers.each do |timer|
            obj_timer = JSON.parse($redis.get(timer.id))
            obj_timer['product_quantity'] += 1
            $redis.set(timer.id, obj_timer.to_json)
          end
          quantity = product.quantity + 1
          product.update_attribute(:quantity, quantity)
        end  
        flash[:success] = 'Cancel Order Success'
        redirect_to user_auctions_path  
      else
        redirect_to user_auctions_path
      end
    end
  end

  def sum_order_date
    respond_to do |format|
      arr_order = Order.all.group_by { |order| order.created_at.to_date }
      format.json { render json: arr_order.to_json }
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
