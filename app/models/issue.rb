class Issue < ActiveRecord::Base
  validates :year, presence: true, numericality: true
  validates :volume, presence: true, numericality: true
    
  has_many :submissions
  
  def title
    "#{self.volume}\/#{self.year}"
  end

	def prepared_submissions
   prepared=self.submissions.where(added:true)
	 prepared.empty? ? false : prepared

  end
  
  def prepare_to_publish(ids)	
		if ids
			submissions=self.submissions.all
			submissions.each do |submission|
				submission.update_attributes(added: false) 
			end
			if ids[:submission_ids]
		  	ids[:submission_ids].each do |id|
					submission=Submission.find_by_id(id)
					if submission
						submission.update_attributes(added: true) 
					end   
				end
			end
		else
			false
		end
	end
end
