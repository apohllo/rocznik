class PublicRevisionMailer < ApplicationMailer
  def public_revision_notification(revision)
    @revision = article_revision
    mail(from: @revision.person.email, to: @revision.person.email, subject: 'Nowa wersja artykułu')
  end
end
