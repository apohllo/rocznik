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
      redirect_to profile_path
    else
      render :edit
    end
  end
  
  def update_password
    @user = current_user
    @person = Person.find_by_email(@user.email)
    if @user.valid_password?(params[:user][:current_password])
      if @user.update_attributes(user_params)
        sign_in @user, :bypass => true
        redirect_to profile_path
      else
        render :edit_password
      end
    else
      render :edit_password
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def person_params
    params.require(:person).permit(:name,:surname,:degree)
  end
end
