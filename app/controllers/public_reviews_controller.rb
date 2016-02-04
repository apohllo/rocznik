class PublicReviewsController < ApplicationController

  def new_reviewer
    @person = Person.new
  end

  def create_reviewer
    if
      @person = Person.find(params[:person_id].where(Person.email == @person.email))
      flash[:success] = 'Osoba już istnieje.'
    else
      @person = Person.new(author_recommendation_params)
      if @author_recommendation.save
        if params[:from]
          redirect_to params[:from]
        else
          flash[:error] = 'Niepoprawne wywołanie.'
          redirect_to public_reviews_path
        end
      else
        @from = params[:from]
        render :new
      end
      review = Review.new(params[:author_recommendation])
    end
  end 

  def finish_recommendation
    flash[:success] = 'Dziękujemy za zgłoszenie'
  end

  private
  def author_recomendation_params
    params.require(:person).permit(:name,:surname,:email,:sex,roles: [])
  end
end
