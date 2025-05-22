require "test_helper"

class GeneratePdfJob < ApplicationJob
  queue_as :default

  def perform(user_id, post_id = nil)
    user = User.find(user_id)
    posts = post_id.present? ? [Post.find(post_id)] : Post.all

    pdf = WickedPdf.new.pdf_from_string(
      ApplicationController.render(
        template: "posts/pdf",
        layout: false,
        locals: { posts: posts }
      )
    )

    file_path = Rails.root.join("tmp", "posts_#{user.id}.pdf")
    File.open(file_path, "wb") { |f| f << pdf }

    PostPdfMailer.send_pdf(user, file_path).deliver_now

    File.delete(file_path) if File.exist?(file_path)
  end
end

