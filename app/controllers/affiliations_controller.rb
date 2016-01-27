class AffiliationsController < ApplicationController
  before_action :admin_required, except:
    [:autocomplete_institution_name,:autocomplete_country_name,:autocomplete_department_name]
  autocomplete :country, :name
  autocomplete :institution, :name
  autocomplete :department, :name

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

  def autocomplete_department_name
    departments = Department.where("LOWER(departments.name) ILIKE ?",params[:term]+"%").
      order(:name).all.map(&:name).uniq
    render json: departments.map{|name| {label: name, value: name } }
  end

  private
  def affiliation_params
    params.require(:affiliation).permit(:year_from,:year_to)
  end
end
