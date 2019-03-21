# == Schema Information
#
# Table name: items
#
#  id         :bigint(8)        not null, primary key
#  order_id   :bigint(8)
#  product_id :bigint(8)
#  amount     :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Item < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :order
  belongs_to :product
end
