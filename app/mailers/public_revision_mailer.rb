class PublicRevisionMailer < ApplicationMailer
  def public_revision_notification(revision)
    @revision = article_revision
    mail(from: , to: @revision.editor_email, subject: 'Nowa wersja artykułu')
  end
end
