class Issue < ActiveRecord::Base
  validates :year, presence: true, numericality: true
  validates :volume, presence: true, numericality: true
    
  has_many :submissions
  has_many :articles
  
  def title
    "#{self.volume}\/#{self.year}"
  end
  
  def accepted
    self.submissions.where(status: "przyjęty")
  end

	def prepared_submissions
   prepared=self.submissions.where(added:true)
	 prepared.empty? ? false : prepared
  end

  def submissions_ready?
		self.submissions.where(status: "przyjęty").empty? ? false : true
  end
  
  def prepare_to_publish(ids)	
		if ids[:submission_ids]
	    ids[:submission_ids].each do |id|
				submission=Submission.find_by_id(id)
				if submission
            article=Article.create(submission: submission, issue: self, status: "przygotowany do publikacji")
						self.update_attributes(prepared: true) 
				end   
			end
		else
			false
		end
	end

end
