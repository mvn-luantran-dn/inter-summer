class Products::ShowSerializer < ApplicationSerializer
  attributes %i[name color size material weight]

  has_many :assets, serializer: Assets::MetaSerializer
end
