class Orders::ShowSerializer < ApplicationSerializer
  attributes %i[abc]

  def abc
    object
  end
end
