class Affiliation < ActiveRecord::Base
  validates :person_id, presence: true
  validates :department_id, presence: true

  belongs_to :person
  belongs_to :department

  def person_name
    self.person.full_name
  end

  def department_full_name
    self.department.full_name
  end

  def department_name
    self.department.name
  end

  def country
    self.department.country
  end

  def institution
    self.department.institution_name
  end

end
