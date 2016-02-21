class SubmissionRegistrationMailer < ApplicationMailer
  def registration_confirmation(submission)
    @submission = submission
    mail(from: @submission.corresponding_author.email, to: @submission.corresponding_author.email, subject: 'Przyjęcie zgłoszenia')
  end
end
