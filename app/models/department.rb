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
end
