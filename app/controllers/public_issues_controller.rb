class PublicIssuesController < ApplicationController
  
  def index
    @issues = Issue.published
  end

  def show
    @issue = Issue.find(params[:id])
  end

end
