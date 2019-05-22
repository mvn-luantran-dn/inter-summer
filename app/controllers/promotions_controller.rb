class PromotionsController < ApplicationController
  before_action :load_products
  def index; end

  private

    def load_products
      @products = Product.includes(:assets, :promotions_categories).select do |pro|
        pro.promotions_categories.present?
      end
    end
end
