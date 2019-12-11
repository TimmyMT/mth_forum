class CommentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_post, only: [:create]
  before_action :set_comment, only: [:destroy, :edit, :update]

  authorize_resource

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@comment.post)
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, post_images_attributes: [:image])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
