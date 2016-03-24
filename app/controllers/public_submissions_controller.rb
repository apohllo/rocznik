# encoding: utf-8

class PublicSubmissionsController < ApplicationController
  before_action -> {set_title "Zgłoszenia"}

  def new
    @submission = Submission.new
    @submission.article_revisions.build(version: 1)
  end

  def create
    @submission = Submission.new(submission_params)
    @submission.status = 'nadesłany'
    @submission.received = DateTime.current
    @submission.article_revisions.first.received = @submission.received

    if @submission.save
      build_authorship
      render :add_author
    else
      render :new
    end
  end


  def add_author
    @authorship = Authorship.new(authorship_params)
    @submission = @authorship.submission
    check_authorship_person
    if @authorship.save
      build_authorship(position: @authorship.position + 1, corresponding: false)
      flash[:notice] = 'Autor został dodany pomyślnie'
      render :add_author
    else
      flash[:error] = 'Wystąpił błąd'
      render :add_author
    end
  end

  def finish
    @submission = Submission.find(params[:id])
    unless Person.editors.count.zero?
      EditorMailer.submission_notification(@submission).deliver_later
    end
    AuthorMailer.confirmation(@submission).deliver_later
  end

  def cancel
    @submission = Submission.find(params[:id])
    @submission.article_revisions.each{|rev| rev.destroy }
    @submission.reload
    @submission.destroy
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
    @authorship = @submission.authorships.build(attrs)
  end

  def authorship_params
    params.require(:authorship).permit(
      :corresponding, :position, :submission_id,
      person_attributes: [:name, :surname, :email, :sex, :discipline]
    )
  end

  def check_authorship_person
    @authorship.person = Person.find_by(email: @authorship.person.email) ||
                        @authorship.person
  end
end
