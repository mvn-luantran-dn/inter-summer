class Orders::ShowSerializer < ApplicationSerializer
  attributes %i[address phone name total_price status city]

  belongs_to :user, serializer: Users::MetaSerializer
  belongs_to :payment, serializer: Payments::MetaSerializer
  has_many :items, serializer: Items::ShowSerializer
end
