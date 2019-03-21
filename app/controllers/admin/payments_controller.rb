class Admin::PaymentsController < Admin::BaseController
  before_action :find_payment, only: %i[show edit update destroy]

  def index
    @payments = Payment.common_order.paginate(page: params[:page], per_page: 10)
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      if params[:payment][:file].present?
        Asset.create!(asset_params.merge(module_type: Payment.name, module_id: @payment.id))
      end
      flash[:success] = I18n.t('payments.create.success')
      redirect_to admin_payments_path
    else
      render :new
    end
  end

  def update
    if @payment.update_attributes(payment_params)
      if params[:payment][:file].present?
        @payment.asset.destroy! if @payment.asset.present?
        Asset.create!(asset_params.merge(module_type: Payment.name, module_id: @payment.id))
      end
      flash[:success] = I18n.t('payments.update.success')
      redirect_to admin_payments_path
    else
      render :edit
    end
  end

  def destroy
    if @payment.destroy!
      flash[:success] = I18n.t('payments.destroy.success')
    else
      flash[:danger] = I18n.t('payments.destroy.error')
    end
    redirect_to admin_payments_url
  end

  private

    def payment_params
      params.require(:payment).permit(:name, :description, :detail)
    end

    def asset_params
      params.require(:payment).permit(:file)
    end

    def find_payment
      @payment = Payment.find_by(id: params[:id])
      redirect_to '/404' unless @payment
    end
end
