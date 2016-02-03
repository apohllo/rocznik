class PublicIssuesController < ApplicationController
  
  def index
    @issues = Issue.published
  end

  def show
    @issue = Issue.find_by_volume(params[:id])
  end

end
