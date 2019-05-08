# == Schema Information
#
# Table name: promotions_categories
#
#  id           :bigint(8)        not null, primary key
#  category_id  :bigint(8)
#  promotion_id :bigint(8)
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  discount     :integer          not null
#

class PromotionsCategory < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :promotion
  belongs_to :category

  scope :common_order, -> { order('id DESC') }
end
