class Asset < ApplicationRecord
  attr_accessor :_destroy
  belongs_to :module, polymorphic: true
  mount_uploader :file_name, PictureUploader
end
