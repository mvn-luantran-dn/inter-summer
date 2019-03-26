# == Schema Information
#
# Table name: users
#
#  id                :bigint(8)        not null, primary key
#  name              :string           not null
#  email             :string           not null
#  password_digest   :string
#  remember_digest   :string
#  role              :string
#  provider          :string
#  uid               :string
#  activation_digest :string
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#  deleted_at        :datetime
#  address           :string
#  phone             :string
#  gender            :integer          default("male"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :boolean
#  root              :boolean          default(FALSE)
#  deactivated_at    :datetime
#  birth_day         :date
#

class User < ApplicationRecord
  acts_as_paranoid
  strip_attributes
  has_secure_password

  GENDER_MALE    = 1
  GENDER_FEMALE  = 2
  GENDER_OTHER   = 3

  enum gender: { male: GENDER_MALE, female: GENDER_FEMALE, other: GENDER_OTHER }

  ROLE_ADMIN = 'admin'.freeze
  ROLE_USER  = 'user'.freeze

  enum role: { admin: ROLE_ADMIN, user: ROLE_USER }

  has_one :asset, as: :module, dependent: :destroy
  has_many :auction_details
  has_many :notifications
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PHONE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :password_confirmation, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :role, presence: true
  validates :address, presence: true, length: { minimum: 10 }
  validates :phone, presence: true, length: { maximum: 15 },
                    format: { with: PHONE_REGEX }, numericality: true
  scope :search_name_email, ->(content) { where 'name LIKE ? or email LIKE ? ', "%#{content}%", "%#{content}%" }
  scope :common_order, -> { order('id DESC') }
  scope :include_basic, -> { includes(:asset) }
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def self.find_or_create_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.first_name + ' ' + auth.info.last_name
      user.email = auth.info.email
      user.password = '123456'
      user.role = 'user'
      user.activated_at = Time.zone.now
      user.save!
    end
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
