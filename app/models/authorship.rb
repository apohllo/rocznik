class Authorship < ActiveRecord::Base
  belongs_to :person
  belongs_to :submission

  def author
    self.person.full_name
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
