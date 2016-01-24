class PublicIssuesController < ApplicationController
  
  def index
    @issues = Issue.where(published: true)
  end

  def show
    @issue = Issue.find(params[:id])
  end

end
