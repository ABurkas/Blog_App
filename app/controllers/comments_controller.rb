class CommentsController < ApplicationController
  before_action :set_post
  #before_action :authenticate_user!, only: [:create]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user if user_signed_in?

    if @comment.save
      redirect_to @post, notice: "Komentarz dodany."
    else
      redirect_to @post, alert: "Komentarz nie został dodany."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

