class Person < ActiveRecord::Base
  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true
  validates :discipline, presence: true

  has_many :affiliations, dependent: :destroy

  def full_name
    "#{self.degree} #{self.name} #{self.surname}"
  end
end
