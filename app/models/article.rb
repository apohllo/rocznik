class Article < ActiveRecord::Base
  STATUS_MAPPING = {
    "po recenzji" => :after_review,
    "korekta redakcyjna" => :editor_correction,
    "korekta autorska" => :author_correction,
    "opublikowany" => :published
  }
  validates :status, presence: true, inclusion: STATUS_MAPPING.keys
  validates :issue_position, on: :patch, numericality: { only_integer: true, greater_than_or_equal: 1}
  after_create :create_position_order
  before_save :update_position, if: :issue_position_changed?, ignore: :create
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

  private
  def get_articles
    Article.all.where("issue_id = ?", self.issue_id)
  end

  def update_position
    old_article = Article.where("issue_id = ?", self.issue_id).where("issue_position = ?", self.issue_position).first
    old_position = Article.where("id = ?", self.id).first.issue_position
    return old_article.update_column(:issue_position, old_position) unless old_article.nil?
    false
  end

  def create_position_order
    taken_position = map_position
    if taken_position.length > 1
      taken_position = (1..taken_position.length+1).to_a - taken_position
      self.update_column(:issue_position, taken_position[0])
    end
  end
end
