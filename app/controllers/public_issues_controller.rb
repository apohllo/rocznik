class PublicIssuesController < ApplicationController
  before_action -> {set_title "Numery rocznika"}

  def index
    @issues = Issue.published
  end

  def show
    @issue = Issue.find_by_volume(params[:id])
  end

end
