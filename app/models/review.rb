class Review < ActiveRecord::Base
  STATUS_MAPPING = {
    "wysłane zapytanie" => :asked, "recenzja przyjęta" => :accepted, "recenzja odrzucona" => :rejected,
    "recenzja pozytywna" => :positive, "recenzja negatywna" => :negative, "niewielkie poprawki" => :minor_review,
    "istotne poprawki" => :major_review,
    "przedłużony termin" => :extension, "blacklista" => :blacklist
  }
  belongs_to :person
  belongs_to :article_revision

  validates :status, inclusion: STATUS_MAPPING.keys
  validates :person_id, presence: true
  validates :article_revision_id, presence: true
  validates :status, presence: true
  validates :asked, presence: true

  def title
    "#{self.article_revision.title}"
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

  def average
    "TODO"
  end
end
