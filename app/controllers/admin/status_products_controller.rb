class Admin::StatusProductsController < Admin::BaseController
  
  def sale
    product = Product.find_by(id: params[:id])    
    product.sale_product
    redirect_to admin_products_url
  end

  def unsale
    product = Product.find_by(id: params[:id])
    product.un_sale_product
    redirect_to admin_products_url
  end
end
