class PublicReviewsController < ApplicationController

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
      @revision = ArticleRevision.find(params[:revision_id])
      review = Review.create(person: @person, article_revision: @revision)
      @person = Preson.new
    end
    flash[:success] = 'Pozycja została dodana pomyślnie.'
  end 

  def finish
    flash[:success] = 'Dziękujemy za zgłoszenie'
  end

  private
  def person_params
    params.require(:person).permit(:name,:surname,:discipline,:email,:sex,roles: [])
  end
end
