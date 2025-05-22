require 'base64'

class GeneratePdfJob < ApplicationJob
  queue_as :default

  def perform(user_id, post_id = nil, email = nil)
    Rails.logger.debug "GeneratePdfJob uruchomiony! user_id: #{user_id}, post_id: #{post_id.inspect}, email: #{email}"
    user = User.find(user_id)
    recipient_email = email.presence || user.email

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

    post = nil
    if post_id.present?
      post = Post.find_by(id: post_id)

      unless post
        Rails.logger.error "GeneratePdfJob: Post with id=#{post_id} not found."
        return
      end

      pdf.text "Post: #{post.title}", size: 24, style: :bold
      pdf.move_down 20
      pdf.text post.body, size: 12

      filename = "post_#{post.id}.pdf"
      subject = "PDF posta: #{post.title}"
    else
      posts = Post.order(created_at: :desc)
      pdf.text "Wszystkie posty", size: 24, style: :bold
      pdf.move_down 20

      posts.each_with_index do |post, index|
        pdf.text "#{index + 1}. #{post.title}", size: 16, style: :bold
        pdf.move_down 5
        pdf.text post.body, size: 12
        pdf.move_down 15
      end

      filename = "wszystkie_posty.pdf"
      subject = "PDF wszystkich postów"
    end

    tmp_path = Rails.root.join("tmp", filename)
    #pdf_data = pdf.render
    pdf_data = Base64.encode64(pdf.render)

    PostPdfMailer.with(
      user: user,
      post: post,
      filename: filename,
      pdf: pdf_data,
      recipient_email: recipient_email,
      subject: subject
    ).send_post_pdf.deliver_later
  end
end