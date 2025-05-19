class Admin::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def index
    authorize [:admin, Comment]
    @comments = @post.comments
  end

  def destroy
    authorize [:admin, @comment]
    @comment.destroy
    redirect_to admin_post_comments_path(@post), notice: "Komentarz usunięty."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end
end
