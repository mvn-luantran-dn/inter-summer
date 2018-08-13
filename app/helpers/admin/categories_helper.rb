module Admin::CategoriesHelper
  def parent_name(id)
    Category.find_by(id: id).name
  end
end
