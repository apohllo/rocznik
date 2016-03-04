class PublicRevisionMailer < ApplicationMailer
  def notification(revision)
    @revision = revision
    mail(to: @revision.editor_email, subject: 'Nowa wersja artykułu')
  end
end
