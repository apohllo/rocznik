class NewuserMailer < ApplicationMailer
  def add(person)
    @person = person
    mail(from: @.article_revision.submission.person.email,
 to: @submission.person.email, subject: 'Informacja o nowym zgłoszeniu oraz rejesracji w systemie.')
  end
 end
