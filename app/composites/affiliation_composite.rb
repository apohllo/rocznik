class AffiliationComposite
  include ActiveModel::Model
  attr_accessor :country, :institution, :department, :year_from, :year_to, :person, :person_id

  def country_label=(value)
    @country = value
  end

  def institution_label=(value)
    @institution = value
  end

  def department_label=(value)
    @department = value
  end

  def person_name
    @person.full_name
  end

  def person_id
    @person_id || @person.id
  end

  def save
    @person = Person.find(@person_id)
    return false unless self.valid?
    department = Department.register!(@department, @institution, @country)
    Affiliation.create(year_from: @year_from, year_to: @year_to, department: department, person: person)
  rescue ActiveRecord::RecordInvalid => ex
    ex.record.errors.each{|a,e| self.errors.add(ex.record.class.name.dasherize.downcase,e) }
    false
  end
end
