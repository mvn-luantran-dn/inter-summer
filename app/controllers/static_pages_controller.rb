class StaticPagesController < ApplicationController
  def home
    @products = Product.all
    @categories = Category.all
  end
end
