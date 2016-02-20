# encoding: utf-8

class UserSubmissionsController < ApplicationController
  before_action :user?

  def index
    @query_params = params[:q] || {}
    @query = Submission.ransack(@query_params)
    @query.sorts = ['received asc'] if @query.sorts.empty?
    @submissions = @query.result(distinct: true)
  end

  def show
    @submission = Submission.find(params[:id])
  end
end
