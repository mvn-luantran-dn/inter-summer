class PromotionsController < ApplicationController
  before_action :load_products
  def index; end

  private

    def load_products
      @products = Product.includes(:assets, category: [promotions_categories: :promotion])
                         .select do |pro|
        pro.promotions_categories.present?
      end
    end
end
