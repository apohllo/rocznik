# encoding: utf-8

class UserSubmissionsController < ApplicationController
  before_action :user_required  

  def index
    @submissions = current_person.submissions
  end

  def show
    @submission = current_person.submissions.find(params[:id])
    if @submission.nil?
      redirect_to user_submissions_path
    end
  end
end
