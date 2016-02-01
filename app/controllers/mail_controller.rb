class MailController < ApplicationController
  before_action :admin_required

  def write_email
    @simplemail.addressee = 
    @simplemail.subject
    @simplemail.body
    @simplemail.sender = current_user.email
  end

  def send_email
    @mail = UserMailer.new
  end



