# encoding: utf-8

class UserSubmissionsController < ApplicationController
  before_action :user_required  

  def index
    @submissions = current_person.authorships.map(&:submission)
  end

  def show
    authorship = current_person.authorships.where(submission_id: params[:id]).first
    if authorship.nil?
      redirect_to user_submissions_path
      flash[:error] = "Brak zgłoszenia o tym identyfikatorze"
      return
    end
    @submission = authorship.submission
  end
end
