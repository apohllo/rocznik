class Authorship < ActiveRecord::Base
  validates :person, presence: true, uniqueness: { scope: :submission_id }
  validates :submission, presence: true

  belongs_to :person
  belongs_to :submission

  accepts_nested_attributes_for :person

  def author
    if self.person
      self.person.full_name
    else
      "[BRAK AUTORA]"
    end
  end

  def email
    if self.person
      self.person.email
    else
      "[BRAK ADRESU E-MAIL]"
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
