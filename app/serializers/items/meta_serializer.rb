class Items::MetaSerializer < ApplicationSerializer
  attributes :amount, :name, :description, :category

  def amount
    object.amount / 23332
  end

  def name
    object.product.name
  end

  def description
    'Paypal'
  end

  def category
    object.product.category.name
  end
end
