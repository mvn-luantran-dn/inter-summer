class Categories::ShowSerializer < ApplicationSerializer
  attributes :name, :description

  has_many :products, serializer: Products::ShowSerializer
  has_one :asset, serializer: Assets::MetaSerializer
end
