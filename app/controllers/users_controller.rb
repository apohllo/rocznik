class UsersController < ApplicationController
  
 
 def new
     @person = Person.new
   end
 
   def create
     @person = Person.new(person_params)
	if Person.new.exists?(:email => email)
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
 
     def person_params
       params.require(:person).permit(:name, :surname, :email, :password, :password_confirmation, :sex, :knowledge, :status)
     end
 end
 
