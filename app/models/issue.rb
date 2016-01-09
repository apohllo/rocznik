class Issue < ActiveRecord::Base
  validates :year, presence: true
  validates :volume, presence: true
    
  has_many :submissions
  
  def issue_data
    "#{self.year} #{self.volume}"
  end
end
