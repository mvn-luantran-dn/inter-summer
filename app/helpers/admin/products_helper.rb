module Admin::ProductsHelper
  def image_first_of_object(product)
    product.assets.first.file_url
  end
end
