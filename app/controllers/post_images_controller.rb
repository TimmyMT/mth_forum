class PostImagesController < ApplicationController

  def destroy
    set_post_image
    @post_image.destroy if current_user == @post_image.post.user
  end

  private

  def set_post_image
    @post_image = PostImage.find(params[:id])
  end

end
