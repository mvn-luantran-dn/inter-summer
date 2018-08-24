class CategoriesController < ApplicationController
  def show
    @category = Category.find_by(id: params[:id]) || redirect_to_not_found
  end
end
