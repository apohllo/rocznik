class Review < ActiveRecord::Base
  STATUS_MAPPING = {
    "wysłane zapytanie" => :asked, "recenzja przyjęta" => :accepted, "recenzja odrzucona" => :rejected,
    "recenzja pozytywna" => :positive, "recenzja negatywna" => :negative, "niewielkie poprawki" => :minor_review,
    "istotne poprawki" => :major_review,
    "przedłużony termin" => :extension, "blacklista" => :blacklist, "proponowany recenzent" => :reviewer_proposal
  }
  belongs_to :person
  belongs_to :article_revision

  validates :status, inclusion: STATUS_MAPPING.keys, presence: true
  validates :person_id, presence: true
  validates :article_revision_id, presence: true
  validates :asked, presence: true
  validate :authors_reviewer_shared_institutions

  def title
    "#{self.article_revision.title}"
  end

  def abstract
    self.submission.abstract
  end

  def editor
    self.submission.editor
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
      "[BRAK DATY]"
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

end
