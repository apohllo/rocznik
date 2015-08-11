class Authorship < ActiveRecord::Base
  belongs_to :person
  belongs_to :submition

  def author
    self.person.full_name
  end

  def title
    self.submition.title
  end
end
