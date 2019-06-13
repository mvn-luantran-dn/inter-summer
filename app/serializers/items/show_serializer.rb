class Items::ShowSerializer < ApplicationSerializer
  attributes :amount, :deleted_at

  belongs_to :product, serializer: Products::ShowSerializer

  def deleted_at
    object.deleted_at&.strftime('%Y-%m-%d') || object.order.updated_at.strftime('%Y-%m-%d')
  end

  def amount
    number_with_delimiter(object.amount, delimiter: ',') + ' VND'
  end
end
