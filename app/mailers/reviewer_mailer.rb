class ReviewerMailer < ApplicationMailer

  def reminder(review)
    @review = review
    mail(to: @review.person.email, from: @review.article_revision.editor,
         subject: 'Przypomnienie o upływającym terminie recenzji')
  end
end
