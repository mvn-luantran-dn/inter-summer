class PromotionsCategory < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :promotion
  belongs_to :category

  scope :common_order, -> { order('id DESC') }
end
