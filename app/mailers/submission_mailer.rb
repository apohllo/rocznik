class SubmissionMailer < ApplicationMailer
  def confirmation(submission)
    @submission = submission
    mail(from: , to: @submission.corresponding_author_email, subject: 'Przyjęcie zgłoszenia')
  end
end
