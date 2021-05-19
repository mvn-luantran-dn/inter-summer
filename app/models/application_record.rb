class ApplicationRecord < ActiveRecord::Base
  include Common::Const
  self.abstract_class = true
end
