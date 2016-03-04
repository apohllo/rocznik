class EditorMailer < ApplicationMailer

  def submission_notification(submission)
    @submission = submission
    editor_emails = Person.editors.pluck(:email)

    mail(to: editor_emails, subject: 'Nowe zgłoszenie artykułu')
  end
end
