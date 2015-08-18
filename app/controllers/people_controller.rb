class PeopleController < ApplicationController
  def index
    @people = Person.order([:surname,:name]).all
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
    params.require(:person).permit(:name,:surname,:degree,:email,:discipline,roles: [])
  end
end
