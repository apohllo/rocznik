class Country < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :institutions, dependent: :restrict_with_error

  def self.register!(name)
    country = Country.where(name: name).first
    country = Country.create!(name: name) if country.nil?
    country
  end
end
