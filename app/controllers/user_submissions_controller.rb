# encoding: utf-8

class UserSubmissionsController < ApplicationController
  before_action :user_required  

  def index
    @submissions = current_person.authorships.map(&:submission)
  end

  def show
    @submission = current_person.authorships.map(&:submission)
    if @submission.nil?
      redirect_to user_submissions_path
    end
  end
end
