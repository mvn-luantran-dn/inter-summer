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
#  city        :string
#

class Order < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  attr_reader :redirect_uri, :popup_uri

  STATUS_WAITTING   = 'waitting'.freeze
  STATUS_ORDERED    = 'ordered'.freeze
  STATUS_DELIVERY   = 'delivering'.freeze
  STATUS_COMPETED   = 'completed'.freeze
  STATUS_CANCLED    = 'canceled'.freeze
  STATUS            = %w[waitting ordered delivering completed canceled].freeze
  STATUS_CAN_CANCLE = %w[waitting ordered].freeze
  STATUS_UPDATE     = %w[ordered delivering completed canceled].freeze

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

  def setup!(return_url, cancel_url)
    payment_request = payment_request 100
    response = client.setup(
      payment_request,
      return_url,
      cancel_url,
      pay_on_paypal: true
    )
    self.token = response.token
    self.save! rescue false
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save! rescue false
    self
  end

  def complete!(payer_id = nil)
    payment_request = payment_request 100
    response = client.checkout!(self.token, payer_id, payment_request)
    self.payer_id = payer_id
    self.transaction_id = response.payment_info.first.transaction_id
    self.purchased_at = Time.zone.now
    self.status = STATUS_ORDERED
    self.save! rescue false
    self
  end

  def details
    client.details(self.token)
  end

  private

    def client
      Paypal::Express::Request.new PAYPAL_CONFIG
    end

    def payment_request(total)
      t_amount = total
      item = {
        name: 'Paypal name bcc testing',
        description: 'Paypal name bcc testing',
        amount: t_amount,
        category: :Digital
      }
      request_attributes = {
        amount: t_amount,
        description: 'Paypal instance for testing',
        items: [item]
      }
      Paypal::Payment::Request.new request_attributes
    end
end
