class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :download_all_pdf]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :download_pdf]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :asc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Post został utworzony."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post został zaktualizowany."
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post został usunięty."
  end

  def download_pdf
    pdf = Prawn::Document.new

    font_path_normal = Rails.root.join("app", "assets", "fonts", "DejaVuSans.ttf").to_s
    font_path_bold = Rails.root.join("app", "assets", "fonts", "DejaVuSans-Bold.ttf").to_s

    pdf.font_families.update(
      "DejaVuSans" => {
        normal: font_path_normal,
        bold: font_path_bold
      }
    )
    pdf.font "DejaVuSans"

    pdf.text "Post: #{@post.title}", size: 24, style: :bold
    pdf.move_down 20
    pdf.text @post.body, size: 12

    send_data pdf.render,
              filename: "post_#{@post.id}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end

  def download_all_pdf
    pdf = Prawn::Document.new

    font_path_normal = Rails.root.join("app", "assets", "fonts", "DejaVuSans.ttf").to_s
    font_path_bold = Rails.root.join("app", "assets", "fonts", "DejaVuSans-Bold.ttf").to_s

    pdf.font_families.update(
      "DejaVuSans" => {
        normal: font_path_normal,
        bold: font_path_bold
      }
    )
    pdf.font "DejaVuSans"

    pdf.text "Wszystkie posty", size: 24, style: :bold
    pdf.move_down 20

    Post.order(created_at: :desc).each_with_index do |post, index|
      pdf.text "#{index + 1}. #{post.title}", size: 16, style: :bold
      pdf.move_down 5
      pdf.text post.body, size: 12
      pdf.move_down 15
    end

    send_data pdf.render,
              filename: "wszystkie_posty.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    redirect_to posts_path, alert: "Brak uprawnień." unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end