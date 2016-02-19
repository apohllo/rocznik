class SubmissionMailer < ApplicationMailer
  def sentMsg(submission)
    @submission = submission
    mail(from: 'asd@w.pl', to:'asdf@w.pl', subject: 'Informacja o zmianie statusu')
  end
end