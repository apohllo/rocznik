class Article < ActiveRecord::Base
  STATUS_MAPPING = {
    "po recenzji" => :after_review,
    "korekta redakcyjna" => :editor_correction,
    "korekta autorska" => :author_correction,
    "opublikowany" => :published
  }
  validates :status, presence: true, inclusion: STATUS_MAPPING.keys
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

  def abstract
     if self.submission
       self.submission.english_abstract
     else
       "[BRAK STRESZCZENIA]"
     end
  end

  def keywords
    if self.submission
      self.submission.english_keywords
    else
      "[BRAK SŁÓW KLUCZOWYCH]"
    end
  end 

  def affiliations
    if self.submission
      self.submission.authors_institutions    
    else
      "[BRAK AFFILIACJI]"
    end
  end
 
  def pages
   if !self.article_pages.blank?
       self.article_pages
   else
      "[BRAK STRON]"
   end
  end

  def link
    if !self.link_to_article.blank?
      self.link_to_article
    else
      "[BRAK LINKU DO ŚCIÁGNIĘCIA ARTYKUŁU]"
    end
  end
  
  def to_param
    [id, title.parameterize].join("-")
  end
end
