class Authorship < ActiveRecord::Base
  validates :person, presence: true, uniqueness: { scope: :submission_id }
  belongs_to :person
  accepts_nested_attributes_for :person

  belongs_to :submission



  def author
    if person
      self.person.full_name
    else
      "[BRAK AUTORA]"
    end
  end
  
  def mail
    if person
      self.person.mail
    else
      "[BRAK ADRESU E-MAIL]"
    end
  end
  
  def author_role
    if !self.role.blank?
      self.role
    else
      "[BRAK ZDEFINIOWANEJ ROLI]"
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
