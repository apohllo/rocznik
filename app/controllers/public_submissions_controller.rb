# encoding: utf-8

class PublicSubmissionsController < ApplicationController
  before_action -> {set_title "Nowe zgłoszenie"}
  before_action :check_submission, except: [:new, :create]

  def new
    @submission = Submission.new
    @submission.article_revisions.build(version: 1)
    @step = :new
  end

  def create
    @submission = Submission.new(submission_params)
    @submission.status = 'nadesłany'
    @submission.received = DateTime.current
    @submission.article_revisions.first.received = @submission.received

    if @submission.save
      build_authorship
      @step = :authors
      render :add_author
    else
      @step = :new
      render :new
    end
  end


  def add_author
    @authorship = Authorship.new(authorship_params)
    @submission = @authorship.submission
    @authorship.person = Person.find_by(email: @authorship.email) || @authorship.person
    @step = :authors
    if @authorship.save
      build_authorship(position: @authorship.position + 1, corresponding: false)
      flash[:notice] = 'Autor został dodany pomyślnie'
    else
      flash[:error] = 'Wystąpił błąd'
    end
  end

  def add_reviewer
    @submission = Submission.find(params[:id])
    @step = :reviewers
    unless params[:review]
      @review = build_review
      return
    end
    @review = Review.new(review_params)
    @review.person = Person.find_by(email: @review.email) || @review.person
    if @review.save
      @review = build_review
      flash[:notice] = 'Recenzent został dodany pomyślnie'
    else
      flash[:error] = 'Wystąpił błąd: ' + @review.errors.full_messages.join(", ")
    end
  end

  def finish
    @submission = Submission.find(params[:id])
    @step = :finish
    unless Person.editors.count.zero?
      EditorMailer.submission_notification(@submission).deliver_later
    end
    AuthorMailer.confirmation(@submission).deliver_later
  end

  def cancel
    @submission = Submission.find(params[:id])
    @submission.reviews.each{|r| r.destroy }
    @submission.article_revisions.each{|r| r.reload; r.destroy }
    @submission.reload
    @submission.destroy
    puts @submission.errors.full_messages
  end

  private
  def submission_params
    params.require(:submission).
      permit(:author_id, :english_abstract, :english_keywords, :english_title,
             :funding, :language, :polish_title,
             article_revisions_attributes: [ :pages, :pictures, :article ])
  end

  def build_authorship(attrs = {})
    attrs.reverse_merge!(position: 1, person: Person.new)
    @authorship = @submission.authorships.build(attrs)
  end

  def build_review
    review = Review.new
    review.person = Person.new
    review.article_revision = @submission.last_revision
    review
  end

  def authorship_params
    params.require(:authorship).
      permit(:corresponding, :position, :submission_id,
      person_attributes: [:name, :surname, :email, :sex])
  end

  def review_params
    params.require(:review).
      permit(:article_revision_id, :status, :remarks, person_attributes: [:name, :surname, :email, :sex])
  end

  def check_submission
    submission = Submission.find_by_id(params[:id])
    if submission && !submission.fresh?
      flash['error'] = 'Zgłoszenie jest już przetwarzane. Nie można go zmienić.'
      redirect_to root_path
    end
  end

end
