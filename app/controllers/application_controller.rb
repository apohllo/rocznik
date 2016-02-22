class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  helper_method :user?, :admin?, :request_uri
  before_action -> {set_title}

  protected
  def admin_required
    unless admin?
      flash[:error] = 'Akcja wymaga uprawnień administratora'
      redirect_to new_user_session_path
    end
  end

  def user?
    !current_user.nil?
  end

  def admin?
    user? && current_user.admin?
  end

  def request_uri
    self.request.url
  end
  
  private
  def current_person
    raise "User missing" unless current_user
    person = Person.find_by_email(current_user.email)
    raise "Person missing" unless person
    person
  end
end
