class UsersController < ApplicationController
  
 
  def new
    @person = Person.new
	@user = User.new
  end
 
  def create
	@user = User.new(user_params)
    @person = Person.new(person_params)
    if Person.where(email: person_params[:email])
  	  flash[:notice] = "Ten email ma już przypisane konto"
    else
      if @person.save
        log_in @person
        flash[:success] = "Rejestracja przebiegła pomyślnie"
        redirect_to @person
      else
        render :new
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
 
  def person_params
    params.require(:person).permit(:name, :surname, :email, :password, :password_confirmation, :sex, :knowledge, :status)
  end

end
 
