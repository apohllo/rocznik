class SubmissionMailer < ApplicationMailer

  def contract(user)
    @user = user
    attachments["plik.pdf"] = File.read('plik.pdf')
    mail(to: @user.email, subject: 'Umowa wydawnicza')
  end

end
