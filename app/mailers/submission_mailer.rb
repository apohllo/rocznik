class SubmissionMailer < ApplicationMailer
  def confirmation(submission)
    @submission = submission
    mail(to: @submission.corresponding_author_email, subject: 'Przyjęcie zgłoszenia')
  end	

  def send_contract(person)
    @person = person
    attachments["Umowa-wydawnicza.pdf"] = File.read("#{Rails.root}/public/plik.pdf")
    mail(to: @person.email, subject: 'Umowa wydawnicza')
  end

  def send_decision(submission)
    @submission = submission
    mail(to: @submission.person.email, subject: 'Decyzja - Rocznik Kognitywistyczny')
  end
end
