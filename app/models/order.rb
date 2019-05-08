# == Schema Information
#
# Table name: orders
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)
#  address     :string
#  phone       :string
#  name        :string
#  total_price :integer
#  deleted_at  :datetime
#  status      :string           default("waitting"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  payment_id  :integer          not null
#

class Order < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  STATUS_WAITTING  = 'waitting'.freeze
  STATUS_ORDERED   = 'ordered'.freeze
  STATUS_DELIVERY  = 'delivering'.freeze
  STATUS_COMPETED  = 'completed'.freeze
  STATUS_CANCLED   = 'canceled'.freeze
  STATUS           = %w[waitting ordered delivering completed canceled].freeze

  state_machine :status, initial: :waitting do
    state :waitting,   value: STATUS_WAITTING
    state :ordered,    value: STATUS_ORDERED
    state :delivering, value: STATUS_DELIVERY
    state :completed,  value: STATUS_COMPETED
    state :canceled,   value: STATUS_CANCLED

    event :order_action do
      transition waitting: :ordered
    end

    event :delivery_action do
      transition ordered: :delivering
    end

    event :complete_action do
      transition delivering: :completed
    end

    event :cancel_action do
      transition %i[waitting ordered] => :canceled
    end
  end

  belongs_to :user
  has_many   :items, dependent: :destroy
  belongs_to :payment

  PHONE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/

  validates :name, presence: true, length: { maximum: 50 }, on: :update
  validates :address, presence: true, on: :update
  validates :phone, presence: true, length: { maximum: 15 },
                    format: { with: PHONE_REGEX }, numericality: true, on: :update
  validates :payment_id, presence: true, on: :update
  scope :common_order, -> { order('id DESC') }
end
