class Institution < ActiveRecord::Base
  belongs_to :country
  has_many :departments, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :country }
  validates :country_id, presence: true

  def country_name
    self.country.name
  end

  def self.register!(name,country)
    country = Country.register!(country)
    institution = country.institutions.where(name: name).first
    institution = Institution.create!(name: name, country: country) if institution.nil?
    institution
  end
end
