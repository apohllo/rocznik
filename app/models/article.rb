class Article < ActiveRecord::Base
  belongs_to :issue
  belongs_to :submission
  
  def authors
    authorships=self.submission.authorships
    authors=Array.new
    authorships.each do |authorship|
      authors << authorship.person
    end
    authors
  end
  
  def authorsInline
	self.authors.empty? ? "[autor nieznany]" :  self.authors.map(&:full_name).join(',')
  end
  
  def authorsAndTitle
    "#{self.authorsInline};  '#{self.submission.title}'"
  end
end
