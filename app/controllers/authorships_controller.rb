class AuthorshipsController < ApplicationController
  before_action :admin_required
  layout "admin"
  before_action -> {set_title "Autorzy"}

  def new
    @authorship = Authorship.new
    @authorship.submission = Submission.find(params[:submission_id])
    @authorship.position = @authorship.submission.authorships.count + 1
    if @authorship.position == 1
      @authorship.corresponding = true
    else
      @authorship.corresponding = false
    end
  end

  def create
    submission = Submission.find(params[:submission_id])
    @authorship = Authorship.new(authorship_params)
    @authorship.submission = submission
    @email = params[:authorship.person.email]
    @password = create_password
	if @authorship.save
          user = User.find_by_email(params:[authorship.person.email]).nil?
          if user = 0
             user = User.new(email: @email, password: @password, password_confirmation: @password)
             UserMailer.add(@email, @password).deliver_now
          end     
	  redirect_to submission
	else
	  render :new
	end
    end

  def destroy
    authorship = Authorship.find(params[:id])
    authorship.destroy
    redirect_to authorship.submission
  end

  private
  def authorship_params
    params.require(:authorship).permit(:person_id,:corresponding,:position)
  end

  def create_password(len=8) 
        SecureRandom.hex(len)
  end
end
