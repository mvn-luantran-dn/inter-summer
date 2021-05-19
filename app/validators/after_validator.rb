class AfterValidator < ActiveModel::Validator
  def validate(record)
    if time_validation(record)
      record.errors.add(:time_validation, 'End_at must great than start_at')
    end
  end

  private

    def time_validation(record)
      return true if record[:end_at] < record[:start_at]
      false
    end
end
