class Admin::StatusProductsController < Admin::BaseController
  def sale
    product = Product.find_by(id: params[:id])
    product.change_status_to_sale
    redirect_to admin_products_url
  end

  def unsale
    product = Product.find_by(id: params[:id])
    product.change_status_to_unsale
    redirect_to admin_products_url
  end
end
