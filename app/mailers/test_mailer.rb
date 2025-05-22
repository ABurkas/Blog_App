class TestMailer < ApplicationMailer
  def welcome_email
    mail(to: ENV['GMAIL_USERNAME'], subject: 'Test maila z Rails', body: 'To jest testowa wiadomość wysłana przez Rails SMTP z Gmail.')
  end
end
