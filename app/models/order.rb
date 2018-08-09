# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :aution_detail
end
