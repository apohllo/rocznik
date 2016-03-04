class SubmissionMailer < ApplicationMailer
  def confirmation(submission)
    @submission = submission
    mail(to: @submission.corresponding_author_email, subject: 'Przyjęcie zgłoszenia')
  end	

  def send_contract(submission)
    @submission = submission
    @person = @submission.person
    @params = {:addresse => @person.email, 
    		  :subject => 'Umowa wydawnicza', 
    		  :submission =>  @submission}
    attachments["Umowa-wydawnicza.pdf"] = File.read("#{Rails.root}/public/plik.pdf")
    mail(to: @params[:addresse], subject: @params[:subject])
    @message = Message.new(@params)
    @message.save()
  end

  def send_decision(submission)
    @submission = submission
    @params = {:addresse => @submission.person.email, 
    		  :subject => 'Decyzja - Rocznik Kognitywistyczny', 
    		  :submission => @submission}
    mail(to: @params[:addresse], subject: @params[:subject])
    @message = Message.new(@params)
    @message.save()
     
  end
end
