class OrdersController < ApplicationController
  before_action :find_order, only: %i[index edit update destroy]

  def index
    return if @order.blank?

    @items = @order.items
    @total = @items.inject(0) do |_result, item|
      promotion = item.product.promotions_categories
      price = if promotion.present?
                item.amount * (100 - promotion.discount) / 100
              else
                item.amount
              end
      _result += price
    end
  end

  def destroy
    item = Item.find_by(id: params[:id])
    total = @order.total_price - item.amount
    product = item.product
    product.quantity += 1
    if item.destroy
      product.save!
      product.timers.each do |timer|
        obj_timer = JSON.parse($redis.get(timer.id))
        obj_timer['product_quantity'] += 1
        $redis.set(timer.id, obj_timer.to_json)
      end
      @order.update_attribute(:total_price, total)
      @order.destroy unless @order.items.any?
      flash[:success] = 'Delete success'
    else
      flash[:danger] = 'Delete error'
    end
    redirect_to user_orders_path
  end

  def edit
    return if @order.blank?

    @items    = @order.items if @order
    @payments = Payment.all
    @total = @items.inject(0) do |_result, item|
      promotion = item.product.promotions_categories
      price = if promotion.present?
                item.amount * (100 - promotion.discount) / 100
              else
                item.amount
              end
      _result += price
    end
  end

  def update
    @items = @order.items if @order
    @payments = Payment.all
    if params[:payment_id].present?
      payment = Payment.find(params[:payment_id])
      format_params(@order, payment)
      if @order.update_attributes(order_params)
        flash[:success] = 'Completed orderd'
        redirect_to root_path
      else
        flash[:danger] = 'Please input all information'
        render :edit
      end
    else
      flash[:danger] = 'Please input all information'
      render :edit
    end
  end

  private

    def order_params
      params.require(:order).permit(%i[name address phone payment_id city status total_price])
    end

    def format_params(order, payment)
      params[:order][:total_price] = order.total_price + payment.transport_fee
      params[:order][:status] = Order::STATUS_ORDERED
    end

    def find_order
      @order = Order.find_by(user_id: current_user.id, status: Order::STATUS_WAITTING)
    end

    def total(items)
      @total = items.inject(0) do |_result, item|
        promotion = item.product.promotions_categories
        price = if promotion.present?
                  item.amount * (100 - promotion.discount) / 100
                else
                  item.amount
                end
        _result += price
      end
    end
end
