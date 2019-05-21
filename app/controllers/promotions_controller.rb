class PromotionsController < ApplicationController
  before_action :load_products
  def index; end

  private

    def load_products
      @products = Product.all
    end
end
