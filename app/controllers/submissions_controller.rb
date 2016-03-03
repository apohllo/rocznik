# encoding: utf-8

class SubmissionsController < ApplicationController
  before_action :admin_required
  layout "admin"
  before_action -> {set_title "Zgłoszone artykuły"}

  def index
    @query_params = params[:q] || {}
    @query = Submission.ransack(@query_params)
    @query.sorts = ['received desc'] if @query.sorts.empty?
    @submissions = @query.result(distinct: true)
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def new
    @submission = Submission.new
    @submission.received = Time.now
    @submission.status = 'nadesłany'
    @author_id = params[:author_id]
  end

  def create
    @submission = Submission.new(submission_params)
    @author_id = params[:author_id]
    if @submission.save
      if @author_id
	 submission = Submission.new(person_id: @author_id, submission: @submission)
-        submission.save
	 if @submission.corresponding_author_email
          SubmissionMailer.confirmation(submission).deliver_now    
          redirect_to submission
	 else
	  render :new
	 end
      end
      redirect_to @submission
    else
      render :new
    end
  end

  def edit
    @submission = Submission.find(params[:id])
  end

  def update
    @submission = Submission.find(params[:id])
    old_status = @submission.status
    new_status = submission_params[:status]
    if @submission.update_attributes(submission_params)
      check_status(old_status,new_status)
      redirect_to @submission
    else
      render :edit
    end
  end

  def destroy
    submission = Submission.find(params[:id])
    submission.destroy
    flash[:error] = 'nie usunięto zgłoszenia' if !submission.destroyed?
    redirect_to submissions_path
  end

  private
  def submission_params
    params.require(:submission).permit(:issue_id,:status,:language,:received,:funding,
                                       :remarks,:polish_title,:english_title,:english_abstract,
                                       :english_keywords,:person_id,:follow_up_id)
  end

  def check_status(old_status,new_status)
    if old_status != new_status
      if new_status == 'odrzucony' || new_status == 'do poprawy' || new_status == 'przyjęty'
        submission = Submission.find(params[:id])
        SubmissionMailer.send_decision(submission).deliver_now
      end
      if new_status == 'przyjęty'
        authors = Submission.find(params[:id]).authors
        authors.each do |author|
          SubmissionMailer.send_contract(author).deliver_now
        end
        SubmissionMailer.send_contract(submission.person).deliver_now
      end
    end
  end
end
