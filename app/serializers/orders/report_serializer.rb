class Orders::ReportSerializer < ApplicationSerializer
  attributes %i[date count]

  def date
    object&.map do |order|
      order.first.strftime('%B %d, %m, %Y')
    end
  end

  def count
    object&.map do |order|
      order.last.size
    end
  end
end
