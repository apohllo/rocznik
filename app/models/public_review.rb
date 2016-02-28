class Review < ActiveRecord::Base
  STATUS_MAPPING = {
    "wysłane zapytanie" => :asked, "recenzja przyjęta" => :accepted, "recenzja odrzucona" => :rejected,
    "recenzja pozytywna" => :positive, "recenzja negatywna" => :negative, "do poprawy" => :correction,
    "przedłużony termin" => :extension, "blacklista" => :blacklist
  }
  belongs_to :person
  belongs_to :article_revision

  validates :status, inclusion: STATUS_MAPPING.keys
  validates :person_id, presence: true
  validates :article_revision_id, presence: true
  validates :status, presence: true
  validates :asked, presence: true

  after_create :notify_reviewers

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

  def notity_reviewers
    unless Person.reviewers.count.zero?
      EditorMailer.public_review_notification(self).deliver_later
    end
  end
end
