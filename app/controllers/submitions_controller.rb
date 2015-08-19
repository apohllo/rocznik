# encoding: utf-8

class SubmitionsController < ApplicationController
  before_action :admin?

  def index
    @submitions = Submition.order('received desc').all
  end

  def show
    @submition = Submition.find(params[:id])
  end

  def new
    @submition = Submition.new
    @submition.received = Time.now
    @submition.status = 'nadesłany'
    @author_id = params[:author_id]
  end

  def create
    @submition = Submition.new(submition_params)
    @author_id = params[:author_id]
    if @submition.save
      if @author_id
        authorship = Authorship.new(person_id: @author_id,submition: @submition)
        authorship.save
      end
      redirect_to @submition
    else
      render :new
    end
  end

  def edit
    @submition = Submition.find(params[:id])
  end

  def update
    @submition = Submition.find(params[:id])
    if @submition.update_attributes(submition_params)
      redirect_to @submition
    else
      render :edit
    end
  end

  def destroy
    submition = Submition.find(params[:id])
    submition.destroy
    redirect_to submitions_path
  end

  private
  def submition_params
    params.require(:submition).permit(:status,:language,:received,:funding,:remarks,:polish_title,:polish_abstract,:polish_keywords,:english_title,:english_abstract,:english_keywords,:person_id)
  end

end
