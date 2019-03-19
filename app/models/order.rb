class Order < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  STATUS_WAITTING  = 'waitting'.freeze
  STATUS_ORDERED   = 'ordered'.freeze
  STATUS_DELIVERY  = 'delivering'.freeze
  STATUS_COMPETED  = 'completed'.freeze
  STATUS           = %w[waitting ordered delivering completed].freeze

  enum status: {
         waitting:   STATUS_WAITTING,
         ordered:    STATUS_ORDERED,
         delivering: STATUS_DELIVERY,
         completed:  STATUS_COMPETED
       }

  belongs_to :user
  has_many :items, dependent: :destroy

  PHONE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/

  validates :name, presence: true, length: { maximum: 50 }, on: :update
  validates :address, presence: true, on: :update
  validates :phone, presence: true, length: { maximum: 15 },
                    format: { with: PHONE_REGEX }, numericality: true, on: :update
  validates :type_payment, presence: true, on: :update
  scope :common_order, -> { order('id DESC') }
  scope :search, ->(content, status, time_start, time_end) {
                   where 'name = ? or address = ?
                           or phone = ? or type_payment = ? or status = ? or created_at BETWEEN ? AND ?', content, content, content, content, status, time_start, time_end
                 }
  scope :search_end_time, ->(content, status, time_end) {
                            where 'name = ? or address = ?
                                    or phone = ? or type_payment = ? or status = ? or created_at < ?', content, content, content, content, status, time_end
                          }
  scope :search_start_time, ->(content, status, time_start) {
                              where 'name = ? or address = ?
                                      or phone = ? or type_payment = ? or status = ? or created_at > ?', content, content, content, content, status, time_start
                            }
  scope :search_with_out_time, ->(content, status) {
                                 where 'name = ? or address = ?
                                         or phone = ? or type_payment = ? or status = ?', content, content, content, content, status
                               }
end
