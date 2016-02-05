class Department < ActiveRecord::Base
  validates :name, presence: true
  validates :institution_id, presence: true

  belongs_to :institution
  has_many :affiliations, dependent: :restrict_with_error

  def institution_name
    self.institution.acronym || self.institution.name
  end

  def full_name
    "#{self.name}, #{self.institution_name}"
  end

  def country
    self.institution.country_name
  end

  def self.register!(name,institution,country)
    institution = Institution.register!(institution,country)
    department = institution.departments.where(name: name).first
    department = Department.create!(name: @department, institution: institution) if department.nil?
    department
  end

  def self.for_autocomplete(term)
    self.where("LOWER(departments.name) ILIKE ?",term+"%").order(:name).
      select(:name).map{|d| {label: d.name, value: d.name } }.uniq
  end
end
