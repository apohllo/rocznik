class AffiliationComposite
  include ActiveModel::Model
  attr_accessor :country, :institution, :department, :year_from, :year_to, :person, :person_id

  def person_name
    @person.full_name
  end

  def person_id
    @person_id || @person.id
  end

  def save
    @person = Person.find(@person_id)
    return false unless self.valid?
    country = Country.where(name: @country).first
    if country.nil?
      country = Country.create!(name: @country)
    end
    institution = Institution.where(name: @institution).where(country_id: country.id).first
    if institution.nil?
      institution = Institution.create!(name: @institution,country_id: country.id)
    end
    department = Department.where(name: @department).where(institution_id: institution.id).first
    if department.nil?
      department = Department.create!(name: @department,institution_id: institution.id)
    end
    affiliation = Affiliation.new(year_from: @year_from, year_to: @year_to)
    affiliation.person = @person
    affiliation.department = department
    affiliation.save!
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
