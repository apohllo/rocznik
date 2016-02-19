class NewuserMailer < ApplicationMailer
  def add(email, password)
    @password = password
    mail(from: @submission.person.email,
 to: @authorship.person.email, subject: 'Konto utworzone.')
  end
 end
