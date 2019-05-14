class Items::ShowSerializer < ApplicationSerializer
  attributes :amount

  belongs_to :product, serializer: Products::ShowSerializer
end
