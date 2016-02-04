class Country < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :institutions, dependent: :restrict_with_error

  def self.register!(name)
    country = Country.where(name: name).first
    country = Country.create!(name: name) if country.nil?
    country
  end

  def self.for_autocomplete(term)
    self.where("LOWER(countries.name) ILIKE ?",term+"%").order(:name).select(:name).map(&:name)
  end
end
