# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  has_many :assets, as: :module, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true
end
