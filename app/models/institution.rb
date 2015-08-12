class Institution < ActiveRecord::Base
  belongs_to :country
  has_many :departments, dependent: :restrict_with_error

  validates :name, presence: true
  validates :country_id, presence: true

  def country_name
    self.country.name
  end
end
