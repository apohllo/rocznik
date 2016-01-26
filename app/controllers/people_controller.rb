class PeopleController < ApplicationController
  before_action :admin_required

  def index
    @query_params = params[:q] || {}
    @query = Person.ransack(@query_params)
    @query.sorts = ['surname asc','name asc'] if @query.sorts.empty?
    @people = @query.result(distinct: true)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to @person
    else
      render :new
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(person_params)
      redirect_to @person
    else
      render :edit
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  private
  def person_params
    params.require(:person).permit(:name,:surname,:degree,:email,:sex,:discipline,:photo,:competence,roles: [])
  end
end
