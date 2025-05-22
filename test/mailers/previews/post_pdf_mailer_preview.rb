# Preview all emails at http://localhost:3000/rails/mailers/post_pdf_mailer
class PostPdfMailerPreview < ActionMailer::Preview
  def send_post_pdf
    user = User.first || User.new(email: "test@example.com", name: "Test User")
    post = Post.first || Post.new(id: 1, title: "Przykładowy post")

    # Przykładowe dane PDF — tutaj możesz użyć zwykłego stringa lub wygenerować prosty PDF
    pdf_content = "%PDF-1.4\n%Fake PDF content for preview\n%%EOF"

    PostPdfMailer.with(user: user, post: post, pdf: pdf_content).send_post_pdf
  end
end
