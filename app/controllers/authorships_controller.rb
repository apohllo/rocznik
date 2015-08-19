class AuthorshipsController < ApplicationController
  before_action :admin?

  def new
    @authorship = Authorship.new
    @authorship.submition = Submition.find(params[:submition_id])
    @authorship.position = @authorship.submition.authorships.count + 1
    if @authorship.position == 1
      @authorship.corresponding = true
    else
      @authorship.corresponding = false
    end
  end

  def create
    submition = Submition.find(params[:submition_id])
    @authorship = Authorship.new(authorship_params)
    @authorship.submition = submition
    if @authorship.save
      redirect_to submition
    else
      render :new
    end
  end

  def destroy
    authorship = Authorship.find(params[:id])
    authorship.destroy
    redirect_to authorship.submition
  end

  private
  def authorship_params
    params.require(:authorship).permit(:person_id,:corresponding,:position)
  end
end
