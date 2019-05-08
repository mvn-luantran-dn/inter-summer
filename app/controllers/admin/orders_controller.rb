class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i[edit update show destroy]
  before_action :list_status, only: %i[edit update]

  def index
    if params[:content].blank? && params[:status].blank? &&
       params[:"date-start"].blank? && params[:"date-end"].blank?
      @orders = Order.paginate(page: params[:page], per_page: 10).common_order
    else
      content = params[:content]
      status = params[:status]
      if params[:"date-end"].blank?
        if params[:"date-start"].blank?
          @orders = Order.search_with_out_time(content, status)
                         .paginate(page: params[:page], per_page: 10)
                         .common_order
        else
          date_start = params[:"date-start"].to_time
          @orders = Order.search_start_time(content, status, date_start)
                         .paginate(page: params[:page], per_page: 10)
                         .common_order
        end
      else
        date_end = params[:"date-end"].to_time
        if params[:"date-start"].blank?
          @orders = Order.search_end_time(content, status, date_end)
                         .paginate(page: params[:page], per_page: 10)
                         .common_order
        else
          date_start = params[:"date-start"].to_time
          @orders = Order.search(content, status, date_start, date_end)
                         .paginate(page: params[:page], per_page: 10)
                         .common_order
        end
      end
    end
  end

  def show
    @items = @order.items.paginate(page: params[:page], per_page: 20)
  end

  def edit; end

  def update
    if @order.update_attributes(order_params)
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

    def order_params
      params.require(:order).permit(%i[status])
    end

    def check_delete_order(order)
      order.status == 'completed'
    end

    def list_status
      @list_status = Order::STATUS.map { |st| st.upcase }
    end
end
