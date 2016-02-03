class PublicReviewsController < ApplicationController

  def index
    @query_params = params[:q] || {}
    @query = Person.ransack(@query_params)
    @query.sorts = ['surname asc','name asc'] if @query.sorts.empty?
    @author_recomendation = @query.result(distinct: true)
  end

  def new
    @author_recomendation = Person.new
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
