class AddedReviewMailer < ApplicationMailer

  def public_review_notification(public_review)
    @public_review = public_review
    reviewer_emails = Person.reviewers.pluck(:email)

    mail(to: reviewer_emails, subject: 'Dodano nową recenzję')
  end
end