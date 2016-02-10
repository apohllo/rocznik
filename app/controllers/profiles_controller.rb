class ProfilesController < ApplicationController
  before_action :user?
   
  def show
    @profile = Profile.find(params[:id])
  end
  
  def edit
    @profile = Profile.find(params[:id])
  end
end