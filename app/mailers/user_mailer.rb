class UserMailer < ApplicationMailer
  def add(email, password)
    @password = password
    mail(from: @submission.corresponding_author.email,
 to: @submission.person.email, subject: 'Konto utworzone.')
  end
 end
