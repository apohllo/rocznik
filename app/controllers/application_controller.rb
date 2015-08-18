class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :user?, :admin?, :request_uri

  protected
  def user?
    !current_user.nil?
  end

  def admin?
    user? && current_user.admin?
  end

  def request_uri
    self.request.url
  end
end
