# encoding: utf-8

class PublicSubmissionsController < ApplicationController
  attr_reader :submission, :authorship

  def new
    @submission = Submission.new
    submission.article_revisions.build(version: 1)
    render :new, locals: { submission: submission }
  end

  def create
    @submission = Submission.new(submission_params)
    submission.status = 'nadesłany'
    submission.received = DateTime.current
    submission.article_revisions.first.received = submission.received

    if submission.save
      build_authorship
      render_add_author
    else
      render :new, locals: { submission: submission }
    end
  end


  def add_author
    @authorship = Authorship.new(authorship_params)
    @submission = authorship.submission

    check_authorship_person

    if authorship.save
      if params[:add_next]
        build_authorship(position: authorship.position + 1)
        render_add_author
      else
        render :submission_confirmation, locals: { submission: submission.reload }
      end
    else
      render_add_author
    end
  end

  def cancel
    @submission = Submission.find(params[:public_submission_id])
    submission.destroy
    render :submission_cancelled
  end 
  
  def authors
    author = Person.find_by(email: params[:email]) if params[:email]
    render json: author
  end

  private

  def submission_params
    params.require(:submission).permit(:author_id, :english_abstract,
                                       :english_keywords, :english_title,
                                       :funding, :language, :polish_title,
                                       article_revisions_attributes: [
                                        :pages, :pictures, :article
                                       ])
  end

  def build_authorship(attrs = {})
    attrs.reverse_merge!(position: 1, person: Person.new)
    @authorship = submission.authorships.build(attrs)
  end

  def authorship_params
    params.require(:authorship).permit(
      :corresponding, :position, :submission_id,
      person_attributes: [:name, :surname, :email, :sex, :discipline]
    )
  end

  def check_authorship_person
    authorship.person = Person.find_by(email: authorship.person.email) ||
                        authorship.person
  end

  def render_add_author
    render :add_author, locals: { authorship: authorship,
                                  submission: submission }
  end
end