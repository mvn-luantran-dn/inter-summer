class ProductsController < ApplicationController
  def show
    @product = Product.find_by(id: params[:id])
  end
end
