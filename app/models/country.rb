class Country < ActiveRecord::Base
  validates :name, presence: true

  has_many :institutions, dependent: :restrict_with_error
end
