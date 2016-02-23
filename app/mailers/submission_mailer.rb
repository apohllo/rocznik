class SubmissionMailer < ApplicationMailer
  def send_decision(submission)
    @submission = submission
    mail(to: @submission.person.email, subject: 'Decyzja - Rocznik Kognitywistyczny')
  end
end