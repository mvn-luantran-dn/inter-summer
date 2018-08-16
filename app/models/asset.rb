class Asset < ApplicationRecord
  attr_accessor :_destroy
  belongs_to :module, polymorphic: true
  validates :file_name, presence: true
  validates :file, presence: true 
  mount_uploader :file_name, PictureUploader
  validate :picture_size
   
  private

    # Validates the size of an uploaded picture.
    def picture_size
      errors.add(:file_name, 'should be less than 5MB') if file_name.size > 5.megabytes
    end
end
