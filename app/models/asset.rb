# == Schema Information
#
# Table name: assets
#
#  id          :bigint(8)        not null, primary key
#  file        :string
#  name        :string
#  module_id   :integer
#  module_type :string
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Asset < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  attr_accessor :_destroy
  belongs_to :module, polymorphic: true
  mount_uploader :file, PictureUploader
  validate :picture_size

  private

    def picture_size
      errors.add(:file, 'should be less than 5MB') if file.size > 5.megabytes
    end
end
