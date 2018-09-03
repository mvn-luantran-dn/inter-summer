class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i[edit update show destroy]

  def index
    if params[:content].blank? and params[:status].blank? and params[:"date-start"].blank? and params[:"date-end"].blank?
      @orders = Order.paginate(page: params[:page], per_page: 10).order('id DESC')
    else
      content = params[:content]
      status = params[:status]
      if params[:"date-end"].blank? 
        if params[:"date-start"].blank?
          @orders = Order.search_with_out_time(content, status).paginate(page: params[:page], per_page: 10).order('id DESC')
        else
          date_start = params[:"date-start"].to_time
          @orders = Order.search_start_time(content, status, date_start).paginate(page: params[:page], per_page: 10).order('id DESC')
        end
      else
        date_end = params[:"date-end"].to_time
        if params[:"date-start"].blank?
          @orders = Order.search_end_time(content, status, date_end).paginate(page: params[:page], per_page: 10).order('id DESC')
        else
          date_start = params[:"date-start"].to_time
          @orders = Order.search(content, status, date_start, date_end).paginate(page: params[:page], per_page: 10).order('id DESC')
        end
      end
      byebug
    end
  end

  def show
    @items = @order.items.paginate(page: params[:page], per_page: 20)
  end

  def edit; end

  def update
    if @order.update_attributes(order_params)
      flash[:success] = 'Update success'
      redirect_to admin_orders_path
    else
      render :edit
    end
  end
  
  def destroy
    if check_delete_order @order
      if @order.destroy
        flash[:success] = "Delete success"
      else
        flash[:notice] = "Delete error"
      end
    else
      flash[:notice] = "Please wait for order checkout"
    end
    redirect_to admin_orders_path
  end
  
  def delete_more_order
    if request.post?
      if params[:ids]
        delete_ids = []
        params[:ids].each do |id|
          if check_delete_order Order.find(id.to_i)
            delete_ids << id.to_i
          else
            redirect_to admin_orders_path, notice: "Please wait for order checkout"
          end
        end
        if delete_ids.length > 0 
          Order.delete_all(:id => delete_ids)
          redirect_to admin_orders_path, notice: "Delete success"
        end
      end
    end
  end

  private

    def find_order
      @order = Order.find_by(id: params[:id]) || redirect_to_not_found
    end

    def order_params
      params.require(:order).permit(%i[status type_payment])
    end

    def check_delete_order order
      return true if order.status == 'received'
      false
    end
end
