class AuthorSubmissionsController < ApplicationController
  before_action :admin_required

  def index
    @reviewers = Reviewers.order('deadline asc').all
    @query_params = params[:q] || {}
    @query = Reviewers.ransack(@query_params)
    @query.sorts = ['deadline asc'] if @query.sorts.empty?
    @reviewers = @query.result(distinct: true)
  end

  def show
    @reviewers = Reviewers.find(params[:id])
  end

  def reviewers
    @reviewers = Reviewers.new
    if params[:submission_id]
      submission = Submission.find(params[:submission_id])
      @reviewers.article_revision = submission.last_revision
      @from = submission_path(submission)
      if @reviewers.article_revision.nil?
        flash[:error] = 'Zgłoszenie nie posiada przypisanych wersji!'
        redirect_to submission
        return
      end
    end
    if params[:person_id]
      person = Person.find(params[:person_id])
      @reviewers.person = person
      @from = person_path(person)
    end
  end

  def reviewers_form
    @reviewers = Reviewers.new(reviewers_params)
    if @reviewers.save
      if params[:from]
        redirect_to params[:from]
      else
        flash[:error] = 'Niepoprawne wywołanie'
        redirect_to submissions_path
      end
    else
      @from = params[:from]
      render :new
    end
  end

  private
  def reviewers_params
    params.require(:reviewers).permit(:name, :surname, :title, :email)
  end 
end
