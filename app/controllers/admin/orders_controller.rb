class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i[edit update show destroy]
  before_action :list_status, only: %i[edit update index]

  def index
    @orders = Order.common_order.to_a
    if params[:start_date].present? && params[:end_date].present?
      @orders.select! do |order|
        order.created_at.between?(params[:start_date].to_date, params[:end_date].to_date)
      end
    end
    return @orders unless params[:status].present?

    @orders.select! { |order| order.status == params[:status].downcase }
  end

  def show
    respond_to do |format|
      format.json do
        order = Order.includes(:payment, user: :asset, items: [product: :assets])
                     .find_by(id: params[:id])
        render json: order, serializer: Orders::ShowSerializer
      end
    end
  end

  def edit; end

  def update
    if @order.update_columns(status: params[:order][:status].downcase)
      flash[:success] = I18n.t('orders.update.success')
      redirect_to admin_orders_path
    else
      render :edit
    end
  end

  def destroy
    if check_delete_order @order
      if @order.destroy
        flash[:success] = I18n.t('orders.destroy.success')
      else
        flash[:danger] = I18n.t('orders.destroy.error')
      end
    else
      flash[:danger] = I18n.t('orders.destroy.alert')
    end
    redirect_to admin_orders_path
  end

  def delete_more_order
    return unless request.post? || params[:ids]

    delete_ids = []
    params[:ids].each do |id|
      if check_delete_order Order.find(id.to_i)
        delete_ids << id.to_i
      else
        flash[:danger] = I18n.t('orders.destroy.alert')
        return redirect_to admin_orders_path
      end
    end
    unless delete_ids.empty?
      Order.where(delete_ids).delete_all
      flash[:success] = I18n.t('orders.destroy.success')
      redirect_to admin_orders_path
    end
  end

  private

    def find_order
      @order = Order.find_by(id: params[:id]) || redirect_to_not_found
    end

    def check_delete_order(order)
      order.status == 'completed'
    end

    def list_status
      @list_status = Order::STATUS_UPDATE.map { |st| st.upcase }
    end
end
