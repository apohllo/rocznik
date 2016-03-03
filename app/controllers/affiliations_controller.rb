class AffiliationsController < ApplicationController
  before_action :admin_required, except: [:institution, :country, :department]
  before_action -> {set_title "Afilacje"}
  layout "admin"

  def new
    @affiliation = AffiliationComposite.new
    @affiliation.person = Person.find(params[:person_id])
  end

  def create
    @affiliation = AffiliationComposite.new(affiliation_params)
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
    params.require(:affiliation_composite).permit(:year_from,:year_to,:institution,:department,:country,
                                                  :person_id,:institution_label,:department_label,:country_label)
  end
end
