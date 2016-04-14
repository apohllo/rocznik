class EditorMailer < ApplicationMailer

  def submission_notification(submission)
    @submission = submission
    editor_emails = Person.editors.pluck(:email)
    if @submission.last_file_path
      attachments["zgloszenie_#{@submission.id}.pdf"] = File.read(@submission.last_file_path)
    end
    mail(to: editor_emails, subject: 'Rocznik Kognitywistyczny - nowe zgłoszenie')
  end
end
