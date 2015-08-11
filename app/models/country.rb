class Country < ActiveRecord::Base
  validates :name, presence: true
  validates :country_id, presence: true

  belongs_to :country
  has_many :institutions, dependent: :restrict_with_error
end
