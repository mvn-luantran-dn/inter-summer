# frozen_string_literal: true

class AutionDetail < ApplicationRecord
  belongs_to :aution
  belongs_to :user
end
