# == Schema Information
#
# Table name: payments
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  description :string
#  detail      :text
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Payment < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  has_many :order
  has_one :asset, as: :module, dependent: :destroy

  scope :common_order, -> { order('id DESC') }
end
