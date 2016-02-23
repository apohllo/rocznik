class UserMailer < ApplicationMailer
  def add(email, password)
    @password = password
    mail(from: @submission.corresponding_author.email,
 to: @submission.person.email, subject: 'Konto utworzone.')
  end
  def send_email(email)
    @body = email.body
    mail(to: email.addressee, from: email.sender, subject: email.subject)
  end
end
