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
  has_many :follow_ups, class_name: "Submission"


  def authors
    self.submission.authorships.map(&:person)
  end

  def authors_inline
    self.authors.empty? ? "[autor nieznany]" : self.authors.map(&:short_name).join(', ')
  end

  def authors_mail
    self.authors.empty? ? "[brak adresów e-mail]" : self.authors.map(&:email).join(', ')
  end

  def authors_metadata
    self.authors.empty? ? "[autor nieznany]" : self.authors.map(&:full_name_without_degree)
  end

  def title
    if self.submission
      self.submission.title(false)
    else
      "[BRAK TYTUŁU]"
    end
  end
  
  def title_original
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

  def article_pages
    if !self.pages.blank?
      self.pages
    else
      "[BRAK STRON]"
    end
  end

  def link
    if !self.external_link.blank?
      self.external_link
    else
      "[BRAK LINKU DO ŚCIÁGNIĘCIA ARTYKUŁU]"
    end
  end

  def year
    if !self.issue.year.blank?
      self.issue.year
    else 
      "[BRAK ROKU WYDANIA]"
    end
  end

  def to_param
    [id, title.parameterize].join("-")
  end  
end
