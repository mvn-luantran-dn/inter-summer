class Products::ShowSerializer < ApplicationSerializer
  attributes %i[name color size material weight price quantity]

  has_many :assets, serializer: Assets::MetaSerializer

  def price
    number_with_delimiter(object.price, delimiter: ',') + ' VND'
  end
end
