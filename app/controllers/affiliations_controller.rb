class AffiliationsController < ApplicationController
  before_action :admin_required, except: [:institution, :country, :department]
  before_action -> {set_title "Afilacje"}
  layout "admin"

  def new
    @affiliation = AffiliationComposite.new
    @affiliation.person = Person.find(params[:person_id])
  end

  def create
    @affiliation = AffiliationComposite.new(params[:affiliation_composite])
    if @affiliation.save
      redirect_to @affiliation.person
    else
      render :new
    end
  end

  def destroy
    affiliation = Affiliation.find(params[:id])
    affiliation.destroy
    redirect_to affiliation.person
  end

  def institutions
    render json: Institution.for_autocomplete(params[:term])
  end

  def departments
    render json: Department.for_autocomplete(params[:term])
  end

  def countries
    render json: Country.for_autocomplete(params[:term])
  end

  private
  def affiliation_params
    params.require(:affiliation).permit(:year_from,:year_to)
  end
end
