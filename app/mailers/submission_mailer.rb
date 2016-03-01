class SubmissionMailer < ApplicationMailer
<<<<<<< HEAD
  def confirmation(submission)
    @submission = submission
    mail(to: @submission.corresponding_author_email, subject: 'Przyjęcie zgłoszenia')
=======

  def send_contract(person)
    @person = person
    attachments["Umowa-wydawnicza.pdf"] = File.read("#{Rails.root}/public/plik.pdf")
    mail(to: @person.email, subject: 'Umowa wydawnicza')
  end

  def send_decision(submission)
    @submission = submission
    mail(to: @submission.person.email, subject: 'Decyzja - Rocznik Kognitywistyczny')
>>>>>>> aa2ec8207599e29d586040a0b17baa8326d2a3f3
  end
end
