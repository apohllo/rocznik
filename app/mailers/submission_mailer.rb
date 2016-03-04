class SubmissionMailer < ApplicationMailer

  def send_contract(submission)
    @submission = submission
    @person = @submission.person
    @params = {:addresse => @person.email, 
    		  :subject => 'Umowa wydawnicza', 
    		  :submissions =>  @submission}
    attachments["Umowa-wydawnicza.pdf"] = File.read("#{Rails.root}/public/plik.pdf")
    mail(to: @params[:addresse], subject: @params[:subject])
    @message = Message.new(@params)
    @message.save()
  end

  def send_decision(submission)
    @submission = submission
    @params = {:addresse => @submission.person.email, 
    		  :subject => 'Decyzja - Rocznik Kognitywistyczny', 
    		  :submissions => @submission}
    mail(to: @params[:addresse], subject: @params[:subject])
    @message = Message.new(@params)
    @message.save()
     
  end
end
