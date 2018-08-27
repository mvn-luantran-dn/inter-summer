class Order < ApplicationRecord
  belongs_to :user
  has_many :items

  PHONE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
  validates :name, presence: true, length: { maximum: 50 }, on: :update
  validates :address, presence: true, on: :update
  validates :phone, presence: true, uniqueness: true, length: { maximum: 15 },
             format: { with: PHONE_REGEX }, numericality: true, on: :update

  scope :search, ->(content) { where 'name LIKE ? or address LIKE ? 
          or phone LIKE ? or type_payment LIKE ?', "%#{content}%", "%#{content}%", "%#{content}%", "%#{content}%" }
end
