class PublicReviewsController < ApplicationController

  def index
    @query_params = params[:q] || {}
    @query = Person.ransack(@query_params)
    @query.sorts = ['surname asc','name asc'] if @query.sorts.empty?
    @author_recomendation = @query.result(distinct: true)
  end

  def new
    @author_recommendation = Person.new
    if params[:person_name, :person_surname]
      person = Submission.find(params[:person_name, :person_surname])
      flash[:error] = 'Osoba już istnieje.'
    else
      if params[:submission_id]
        submission = Submission.find(params[:submission_id])
        @author_recommendation.submission = submission.last_revision
        @from = submission_path(submission)
        if @author_recommendation.submission.nil?
          flash[:error] = 'Propozycja nie została przypisane do zgłoszenia!'
          return
        end
        review = Review.find(params[:review_id])
        @author_recommendation.review = review
        @author_recommendation = person_path(review)
      end    
    end
    @review.status = 'proponowana'
    @review.asked = Time.now
    @review.deadline = 45.days.from_now
  end  
 

  def create
    @author_recomendation = Person.new(author_recomendation_params)
    if @author_recomendation.save
      redirect_to @author_recomendation
    else
      render :new
    end
  end

  private
  def author_recomendation_params
    params.require(:person).permit(:name,:surname,:email,:sex,roles: [])
  end
end
