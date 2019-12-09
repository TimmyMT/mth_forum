class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_category, only: [:new, :create]

  authorize_resource

  def show
    @comments = @post.comments.order(created_at: :desc)
    @comment = @post.comments.new
  end

  def new
    @post = @category.posts.new
    @post.post_images.new
  end

  def create
    @post = @category.posts.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    if @post.destroyed?
      redirect_to category_path(@post.category)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, post_images_attributes: [:image])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
