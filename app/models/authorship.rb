class Authorship < ActiveRecord::Base
  belongs_to :person
  belongs_to :submition

  def author
    self.person.full_name
  end

  def title
    self.submition.title
  end

  def date
    self.submition.received
  end

  def status
    self.submition.status
  end
end
