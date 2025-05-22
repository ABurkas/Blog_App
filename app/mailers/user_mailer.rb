class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def send_pdf(email, post_title, pdf_path)
    attachments["#{post_title.parameterize}.pdf"] = File.read(pdf_path)
    mail(to: email, subject: "Twój PDF z postem: #{post_title}")
  end
end