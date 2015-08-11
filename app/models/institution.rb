class Institution < ActiveRecord::Base
  belongs_to :country
  has_many :departments, dependent: :restrict_with_error

  def country_name
    self.country.name
  end
end
