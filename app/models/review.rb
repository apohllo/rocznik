class Review < ActiveRecord::Base
  STATUS_MAPPING = {
    "proponowany recenzent" => :reviewer_proposal,
    "wysłane zapytanie" => :asked, "recenzja przyjęta" => :accepted,
    "recenzja odrzucona" => :rejected,
    "recenzja pozytywna" => :positive, "recenzja negatywna" => :negative,
    "niewielkie poprawki" => :minor_review,
    "istotne poprawki" => :major_review,
    "przedłużony termin" => :extension, "blacklista" => :blacklist,
    "niechciany recenzent" => :reviewer_rejected
  }
  FINAL_STATUS_LIST = ['recenzja pozytywna', 'recenzja negatywna', 'niewielkie poprawki', 'istotne poprawki']
  belongs_to :person
  belongs_to :article_revision

  validates :status, inclusion: STATUS_MAPPING.keys, presence: true
  validates :person, presence: true, uniqueness: { scope: :article_revision_id }
  validates :article_revision_id, presence: true
  validates :remarks, presence: true, if: -> (r) { r.status == 'niechciany recenzent' }
  validate :authors_reviewer_shared_institutions

  scope :in_progress, -> { where("status = 'wysłane zapytanie' or status = 'recenzja pozytywna' " +
    "or status = 'recenzja negatywna' or status = 'niewielkie poprawki' or status = 'istotne poprawki' " +
    "or status = 'przedłużony termin'") }

  scope :done, -> { where("status = 'recenzja pozytywna' or status = 'recenzja negatywna' " +
    "or status = 'niewielkie poprawki' or status = 'istotne poprawki'") }

  accepts_nested_attributes_for :person

  after_save :make_reviewer

  # The title includes revision id.
  def title
    "#{self.article_revision.title}"
  end

  def done?
    [:accepted, :rejected, :major_review, :minor_review].include?{|e| STATUS_MAPPING.key(self.status) }
  end

  # The title does not include revision id.
  def submission_title
    self.submission.title(false)
  end

  def article_url
    if self.article_revision && self.article_revision.article
      self.article_revision.article.url
    end
  end

  def email
    if self.person
      self.person.email
    else
      "[BRAK ADRESU RECENZENTA]"
    end
  end

  def done?
    FINAL_STATUS_LIST.include?(self.status)
  end

  def proposal?
    self.status == STATUS_MAPPING.key(:reviewer_proposal)
  end

  def asked!
    self.update_attributes(status: STATUS_MAPPING.key(:asked), asked: Time.now)
  end

  def asked?
    self.status == STATUS_MAPPING.key(:asked)
  end

  def accept!(deadline=nil)
    params = { status: STATUS_MAPPING.key(:accepted) }
    params[:deadline] = deadline unless deadline.nil?
    self.update_attributes(params)
  end

  def accepted?
    self.status == STATUS_MAPPING.key(:accepted)
  end

  def reject!
    self.update_attributes(status: STATUS_MAPPING.key(:rejected))
  end

  def rejected?
    self.status == STATUS_MAPPING.key(:rejected)
  end

  def abstract
    self.submission.abstract
  end

  def editor
    self.submission.editor
  end

  def editor_email
    self.submission.editor_email
  end

  def reviewer_email
    self.person.email
  end

  def text
    if self.content.blank?
      "[BRAK TREŚCI]"
    else
      self.content
    end
  end

  def reviewer
    self.person.full_name
  end

  def version
    self.article_revision.version
  end

  def submission
    self.article_revision.submission
  end

  def asked_date
    if self.asked
      self.asked.strftime("%d-%m-%Y")
    else
      "[BRAK DATY ZAPYTANIA]"
    end
  end

  def deadline_date
    if self.deadline
      self.deadline.strftime("%d-%m-%Y")
    else
      "[BRAK DEADLINE'u]"
    end
  end

  def deadline_missed?
    if self.deadline
      self.deadline < Time.now && [:asked,:accepted].map{|t| STATUS_MAPPING.key(t) }.include?(self.status)
    end
  end

  def authors_reviewer_shared_institutions
    authors_institutions = self.article_revision.authors_institutions
    reviewer_institutions = self.person.current_institutions
    shared_institutions = authors_institutions & reviewer_institutions
    if !shared_institutions.empty?
      errors.add(:person,"'#{person.full_name}' ma taką samą afiliację jak jeden z autorów.")
    end
  end

  def salutation
    self.person.salutation
  end

  def make_reviewer
    if self.person
      self.person.reviewer!
    end
  end

  def language_message
    if self.submission
      message = "tekst jest w języku "
      if self.submission.polish_language?
        message << "polskim"
      else
        message << "angielskim"
      end
      message
    else
      "[BRAK INFORMACJI O JĘZYKU]"
    end
  end

  def gender_name
    if self.person
      self.person.gender_name
    else
      "Pan/Pani"
    end
  end
end
