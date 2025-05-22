class PostPdfMailer < ApplicationMailer
  def send_post_pdf

    Rails.logger.debug "PDF class: #{params[:pdf].class}, encoding: #{params[:pdf].encoding}"

    @user = params[:user]
    @post = params[:post]

    pdf_binary = Base64.decode64(params[:pdf])
    attachments[params[:filename]] = {
      mime_type: 'application/pdf',
      content: pdf_binary
    }

    # attachments[params[:filename]] = {
    #   mime_type: 'application/pdf',
    #   content: params[:pdf].force_encoding('BINARY')
    # }

    mail(to: params[:recipient_email], subject: params[:subject])


  end
end
