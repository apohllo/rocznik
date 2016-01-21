class Authorship < ActiveRecord::Base
  validates :person, presence: true

  belongs_to :person
  belongs_to :submission

  def author
    if person
      self.person.full_name
    else
      "[BRAK AUTORA]"
    end
  end

  def title
    self.submission.title
  end

  def date
    self.submission.received
  end

  def status
    self.submission.status
  end
end
