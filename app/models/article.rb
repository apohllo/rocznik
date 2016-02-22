class Article < ActiveRecord::Base
  STATUS_MAPPING = {
    "po recenzji" => :after_review,
    "korekta redakcyjna" => :editor_correction,
    "korekta autorska" => :author_correction,
    "opublikowany" => :published
  }
  validates :status, presence: true, inclusion: STATUS_MAPPING.keys
  validates :issue_position, on: :patch, numericality: { only_integer: true, greater_than_or_equal: 1}
  after_create :assign_issue_position
  belongs_to :issue
  belongs_to :submission

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

  def map_position
    articles = get_articles
    table = Array.new
    articles.each do |article|
      table << article.issue_position
    end
    table
  end

  def update_article_position down = ""
    articles = get_positions
    if down.empty?
      article_position_flip [articles[:article_next]]
    else
      article_position_flip [articles[:article_prev]]
    end
  end

  private
  def get_positions
    articles = get_articles

    {article_next: get_next_article(articles),
     article_prev: get_prev_article(articles)}
  end

  def get_articles
    Article.all.where("issue_id = ?", self.issue_id)
  end

  def get_next_article articles
    articles.where("issue_position > ?", self.issue_position).order(issue_position: :asc).limit(1).first
  end

  def get_prev_article articles
    articles.where("issue_position < ?", self.issue_position).order(issue_position: :desc).limit(1).first
  end

  def article_position_flip article
    if !article[0].nil?
      halp = self.issue_position
      self.update_attributes(issue_position: article[0].issue_position)
      article[0].update_attributes(issue_position: halp)
    end
  end

  def assign_issue_position
    if !get_articles.nil?
      taken_position = map_position
      taken_position = (1..taken_position.length+5).to_a - taken_position
      self.update_column(:issue_position, taken_position[0])
    end
  end
end
