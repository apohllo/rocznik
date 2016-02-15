class MailController < ApplicationController
  before_action :admin_required

  def write_email
    @simplemail = SimpleMail.new 
  end

  def send_email
    @simplemail = SimpleMail.new(mail_params)
    if @simplemail.valid?
      UserMailer.send_email(@simplemail).deliver
      redirect_to submissions_path
    else
      render :write_email
    end
  end
end
