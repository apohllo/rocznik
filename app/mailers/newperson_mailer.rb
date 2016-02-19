class NewuserMailer < ApplicationMailer
  def add(person)
    @person = person
    mail(from: @submission.person.email,
 to: @submission.person.email, subject: 'Informacja o nowym zgłoszeniu oraz rejesracji w systemie.')
  end
 end
