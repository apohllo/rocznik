class Article < ActiveRecord::Base
  STATUS_MAPPING = {
    "korekta redakcyjna" => :editor_correction, "korekta autorska" => :author_correction, "opublikowany" => :published
  }
  belongs_to :issue
  belongs_to :submission
  
  def authors
    self.submission.authorships.map(&:person)
  end
  
  def authors_inline
    self.authors.empty? ? "[autor nieznany]" :  self.authors.map(&:full_name).join(',')
  end
  
  def authors_and_title
    "#{self.authors_inline};  '#{self.submission.title}'"
  end
end
