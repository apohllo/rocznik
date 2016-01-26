class UserInfosController < ApplicationController
 

def new_person
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      log_in @person
      flash[:success] = "Rejestracja przebiegła pomyślnie"
      redirect_to @person
    else
      render 'new_person'
    end
  end
 
private

    def person_params
      params.require(:person).permit(:name, :surname, :email, :password, :password_confirmation, :sex, :knowledge, :status)
    end
end

def new_user
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Rejestracja przebiegła pomyślnie"
      redirect_to @user
    else
      render 'new_user'
    end
  end
 
private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
