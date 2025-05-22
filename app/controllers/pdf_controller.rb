class PdfController < ApplicationController
  def generate_pdf
    post_id = params[:post_id]
    GeneratePdfJob.perform_later(current_user.id, post_id)
    redirect_to posts_path, notice: "PDF jest generowany i zostanie wysłany e-mailem."
  end
end

