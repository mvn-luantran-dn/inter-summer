class StaticPagesController < ApplicationController
  def home; end

  def show
    timer = Timer.find_by(id: params[:id])
    @product = timer.product
  end
end
