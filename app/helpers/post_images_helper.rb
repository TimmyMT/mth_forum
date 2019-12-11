module PostImagesHelper
  def can_destroy?(post_image)
    current_user == post_image.post_imageble.user || current_user&.admin?
  end
end
