class Article < ActiveRecord::Base
  belongs_to :issue
  belongs_to :submission

  def authors
    self.submission.authorships.map(&:person)
  end

  def authors_inline
    self.authors.empty? ? "[autor nieznany]" :  self.authors.map(&:short_name).join(', ')
  end

  def title
    if self.submission
      self.submission.title(false)
    else
      "[BRAK TYTUŁU]"
    end
  end

  def issue_title
    if self.issue
      self.issue.title
    else
      "[BRAK NUMERU]"
    end
  end
  
  def to_param
    [id, title.parameterize].join("-")
  end
end
