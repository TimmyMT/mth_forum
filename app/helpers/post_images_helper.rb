module PostImagesHelper
  def can_destroy?(post_image)
    current_user == post_image.post.user || current_user&.admin?
  end
end
