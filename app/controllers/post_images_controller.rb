class PostImagesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    set_post_image
    @post_image.destroy if current_user == @post_image.post_imageble.user || current_user.admin?
  end

  private

  def set_post_image
    @post_image = PostImage.find(params[:id])
  end

end
