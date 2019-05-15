class Items::ShowSerializer < ApplicationSerializer
  attributes :amount, :deleted_at

  belongs_to :product, serializer: Products::ShowSerializer

  def deleted_at
    object.deleted_at&.strftime('%Y-%m-%d')
  end
end
