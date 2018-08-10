# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :items
  validates :address, presence: true, length: { maximum: 255 }
  PHONE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
  validates :phone, presence: true, length: { maximum: 15 },
                    format: { with: PHONE_REGEX }, numericality: true
end
