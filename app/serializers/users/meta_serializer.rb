class Users::MetaSerializer < ApplicationSerializer
  attributes :name

  has_one :asset, serializer: Assets::MetaSerializer
end
