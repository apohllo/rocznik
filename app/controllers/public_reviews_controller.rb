class PublicReviewsController < ApplicationController
  before_action -> {set_title "Recenzje"}

  def new_reviewer
    @person = Person.new
  end

  def create_reviewer
    @person = Person.where(email: params[:person][:email]).first
    unless @person
      @person = Person.new(person_params)
      unless @person.save
        render :new_reviewer
        return
      end
    end
    @revision = ArticleRevision.find(params[:revision_id])
    Review.create!(person: @person, article_revision: @revision,
                   asked: Time.now, status: "proponowany recenzent")
    @person = Person.new
    flash[:success] = 'Pozycja została dodana pomyślnie.'
    render :new_reviewer
  end

  def finish
    flash[:success] = 'Dziękujemy za zgłoszenie'
  end

def download
  @article = Article.find(params[:id])
  pdf=PdfVersion.new.generate_pdf_version(@article)
  send_data pdf.render, filename: 'article.pdf', type: "application/pdf"

  review_date = 
end

  private
  def person_params
    params.require(:person).permit(:name,:surname,:email,:sex,roles: [])
  end
end
