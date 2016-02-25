class UserMailer < ApplicationMailer
  def add(email, password)
    @password = password
    @email = email
    mail(to: @email, subject: 'Konto utworzone.')
  end
  def send_email(email)
    @body = email.body
    mail(to: email.addressee, from: email.sender, subject: email.subject)
  end
end
