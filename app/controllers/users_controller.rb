class UsersController < ApplicationController
  
 
  def new
	@user = User.new
  end
 
  def create
	@user = User.new(user_params)
    if User.where(email: user_params[:email]).first
  	  flash[:notice] = "Ten email ma już przypisane konto"
      redirect_to new_person_users_path
    else
      if @user.save
        #log_in @user
        redirect_to new_person_users_path
      else
        render :new
      end
    end
  end
  

  def new_person
    @person = Person.new
  end

  def create_person
    @person = Person.new(person_params)
    @person.email = current_user.email
    if Person.where(current_user.email).first
  	  flash[:notice] = "Ten email ma już przypisane dane"
    else
      if @person.save
        flash[:success] = "Rejestracja przebiegła pomyślnie"
        redirect_to "/"
      else
        render new_person_users_path
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  def person_params
    params.require(:person).permit(:name, :surname, :sex)
  end

end
 
