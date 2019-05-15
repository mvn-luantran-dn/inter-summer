class Orders::MetaSerializer < ApplicationSerializer
  include ActionView::Helpers::NumberHelper

  attributes %i[total_price status city quantity]

  belongs_to :payment, serializer: Payments::MetaSerializer

  def quantity
    object.items.size
  end

  def total_price
    number_with_delimiter(object.total_price, delimiter: ',') + ' VND'
  end

  def status
    object.status.upcase
  end
end
