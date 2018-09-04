class Order < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy

  PHONE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
  validates :name, presence: true, length: { maximum: 50 }, on: :update
  validates :address, presence: true, on: :update
  validates :phone, presence: true, length: { maximum: 15 },
                    format: { with: PHONE_REGEX }, numericality: true, on: :update

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
