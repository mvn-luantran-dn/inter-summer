# == Schema Information
#
# Table name: promotions
#
#  id          :bigint(8)        not null, primary key
#  start_date  :datetime
#  end_date    :datetime
#  discount    :integer
#  description :string
#  detail      :text
#  user_id     :bigint(8)
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string           not null
#

class Promotion < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  has_many :promotions_categories, dependent: :destroy
  has_many :categories, through: :promotions_categories
  accepts_nested_attributes_for :promotions_categories, allow_destroy: true
  belongs_to :user
  has_one :asset, as: :module, dependent: :destroy

  scope :common_order, -> { order('id DESC') }
end
