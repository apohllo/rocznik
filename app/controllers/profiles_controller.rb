class ProfilesController < PeopleController
  before_action :user?
   
  def show
    @profile = Person.find(params[:id])
  end
  
  def edit
    @profile = Person.find(params[:id])
  end
end