# frozen_string_literal: true

module Admin::CategoriesHelper
  def parent_name(category)
    Category.find_by(id: category.parent_id).name
  end
end
