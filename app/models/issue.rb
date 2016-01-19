class Issue < ActiveRecord::Base
  validates :year, presence: true, :numericality => {:greater_than => 2000}
  validates :volume, presence: true, numericality: true
    
  has_many :submissions
  
  def title
    "#{self.volume}\/#{self.year}"
  end
end
