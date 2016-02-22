class UserMailer < ApplicationMailer
  def send_email(email)
    @body = email.body
    mail(to: email.addressee, from: email.sender, subject: email.subject)
  end
end
