# encoding: utf-8

class SubmissionsController < ApplicationController
  before_action :admin_required, except: [:new, :create]

  def index
    @submissions = Submission.order('received desc').all
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def new
    @submission = Submission.new
    @submission.status = 'nadesłany'
    @author_id = params[:author_id]

    @submission.authorships.build
  end

  def create
    @submission = Submission.new(new_submission_params)
    @submission.received = Time.now
    @author_id = params[:author_id]
    if @submission.save
      if @author_id
        authorship = Authorship.new(person_id: @author_id,submission: @submission)
        authorship.save
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
    if @submission.update_attributes(update_submission_params)
      redirect_to @submission
    else
      render :edit
    end
  end

  def destroy
    submission = Submission.find(params[:id])
    submission.destroy
    redirect_to submissions_path
  end

  private

  def new_submission_params
    params.require(:submission)
      .permit(:article, :funding,:polish_title,:english_title,
        :english_abstract,:english_keywords,
        authorships_attributes: authorships_params)
  end

  def update_submission_params
    params.require(:submission).permit(:article, :status,:language,:received,:funding,:remarks,:polish_title,:polish_abstract,:polish_keywords,:english_title,:english_abstract,:english_keywords,:person_id)
  end

  def authorships_params
    [{ person_attributes: [:name, :surname, :email, :discipline] }]
  end
end
