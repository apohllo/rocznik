class ProfileController < PeopleController
  before_action :user_required
  
  def show
    @person = Person.find(params[:id])
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
  
  def update_password
  end
  
  private
  def user_params
    params.require(:user).permit(:encrypted_password)
  end
end