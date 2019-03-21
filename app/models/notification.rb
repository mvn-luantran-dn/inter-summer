# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  content    :string
#  user_id    :bigint(8)
#  status     :integer
#  timer_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

class Notification < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :user
end
