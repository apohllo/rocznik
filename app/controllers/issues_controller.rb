class IssuesController < ApplicationController
  before_action :admin_required

  def index
    @query_params = params[:q] || {}
    @query = Issue.ransack(@query_params)
    @query.sorts = ['year desc','volume desc'] if @query.sorts.empty?
    @issues = @query.result(distinct: true)
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)
    if @issue.save
      redirect_to @issue
    else
      render :new
    end
  end
  
  def edit
    @issue = Issue.find(params[:id])
  end
  
  def update
    @issue = Issue.find(params[:id])
    if @issue.update_attributes(issue_params)
      redirect_to @issue
    else
      render :edit
    end
  end
  
  def show
    @issue = Issue.find(params[:id])
  end
  
  private
    
  def issue_params
    params.require(:issue).permit(:year,:volume,roles: [])
  end
    
end
