class OrdersController < ApplicationController
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error
  before_action :find_order, only: %i[index edit update destroy]

  def index
    return if @order.blank?

    @items = @order.items
    @total = total(@items)
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
    @total = total(@items)
  end

  def update
    @items = @order.items if @order
    @payments = Payment.all
    if params[:payment_id].present?
      payment = Payment.find(params[:payment_id])
      format_params(@order, payment)
      if payment.name == 'Paypal'
        @order.update_attributes(order_paypal_params)
        @order.setup!(
          success_user_orders_url,
          cancel_user_orders_url
        )
        redirect_to @order.popup_uri
      elsif @order.update_attributes(order_params)
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

  def success
    handle_callback do |order|
      order.complete!(params[:PayerID])
      flash[:success] = 'Payment Transaction Completed'
      root_path
    end
  end

  def cancel
    handle_callback do |order|
      order.cancel!
      flash[:danger] = 'Payment Request Canceled'
      edit_user_order_path(current_user, order)
    end
  end

  private

    def order_params
      params.require(:order).permit(%i[name address phone payment_id city status total_price])
    end

    def order_paypal_params
      params.require(:order).permit(%i[name address phone payment_id city total_price])
    end

    def format_params(order, payment)
      params[:order][:total_price] = total(order.items) + payment.transport_fee
      params[:order][:payment_id] = params[:payment_id]
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

    def handle_callback
      order = Order.find_by_token!(params[:token])
      @redirect_uri = yield order
      redirect_to @redirect_uri
    end

    def paypal_api_error(error)
      redirect_to edit_user_order_url, error: error.response.details.collect(&:long_message)
                                                   .join('<br />')
    end

    def payment_params
      params.require(:order).permit(:total_price)
    end
end
