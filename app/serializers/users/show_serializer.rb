class Users::ShowSerializer < ApplicationSerializer
  attributes %i[name email phone address gender role birth_day]

  has_one :asset, serializer: Assets::MetaSerializer
  has_many :orders, serializer: Orders::MetaSerializer
  has_many :item_deletes, serializer: Items::ShowSerializer

  def item_deletes
    object.orders.map { |order| order.items.with_deleted - order.items }.flatten!
  end
end
