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

  
    if (@person.congratulations) then
      if(@person.sex == "kobieta") 
          then @salutation = "Pani #{@person.name} #{@person.surname} przyjęła już #{@person.reviews_count} recenzję. <br>
          Gratulujemy i bardzo dziękujemy!"
          elsif (@person.sex == "mężczyzna") 
          then @salutation = "Pan #{@person.name} #{@person.surname} przyjął już #{@person.reviews_count} recenzję. <br>
          Gratulujemy i bardzo dziękujemy!"

          else @salutation = "Użytkownik #{@person.name} #{@person.surname} przyjął już #{@person.reviews_count} recenzję.
          Gratulujemy i bardzo dziękujemy!"
          end
      end
    end


  end
  

  private
  def person_params
    params.require(:person).permit(:name,:surname,:degree,:email,:sex,:photo,:competence,:reviewer_status, roles: [], discipline: [])

  end
end
