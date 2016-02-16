class ProfilesController < ApplicationController
  before_action :user_required
  
  def show
    @user = current_user
    @person = Person.find_by_email(@user.email)
  end
  
  def edit
    @user = current_user
    @person = Person.find_by_email(@user.email)
  end
  
  def edit_password
    @user = current_user
    @person = Person.find_by_email(@user.email)
  end
  
  def update
    @user = current_user
    @person = Person.find_by_email(@user.email)
    if @person.update_attributes(person_params)
      redirect_to @person
    else
      render :edit
    end
  end
  
  def update_password
    @user = current_user
    @person = Person.find_by_email(@user.email)
    if @user.valid_password?(params[:current_password], true)
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      if @user.update_attributes(user_params)
        sign_in @user, :bypass => true
        redirect_to @person
      else
        render :edit_password
      end
    else
      render :edit_password
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
  
  def person_params
    params.require(:person).permit(:name,:surname,:degree,:email,:sex,:photo,:competence,roles: [], discipline: [])
  end
end
