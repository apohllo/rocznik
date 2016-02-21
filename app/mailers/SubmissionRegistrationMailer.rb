class SubmissionRegistrationMailer < ApplicationMailer
  def registration_confirmation(submission)
    @submission = submission
    mail(from: @submission.person.email, to: @submission.person.email, subject: 'Przyjęcie zgłoszenia')
  end
end
