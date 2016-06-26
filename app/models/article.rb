# encoding: utf-8
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
  has_many :follow_ups, class_name: "Submission"
  is_impressionable

  scope :english, -> { joins(:submission).includes(:submission).where("submissions.language = 'angielski'") }
  scope :polish, -> { joins(:submission).includes(:submission).where("submissions.language = 'polski'") }


  def authors
    self.submission.authorships.map(&:person).compact
  end

  def reviews
    self.submission.reviews
  end

  def corresponding_author
    authorship = self.submission.authorships.find{|a| a.corresponding }
    if authorship.nil?
      authorship = self.submission.authorships.first
    end
    if authorship
      authorship.person
    end
  end

  def authors_inline
    self.authors.empty? ? "[autor nieznany]" : self.authors.map(&:short_name).join(', ')
  end

  def author_email
    if self.corresponding_author
      self.corresponding_author.email
    else
      nil
    end
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
      "[BRAK LINKU DO ŚCIĄGNIĘCIA ARTYKUŁU]"
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

  private
  def update_position
    old_article = self.issue.articles.find_by(issue_position: self.issue_position)
    old_position = self.issue.articles.find_by(id: self.id).issue_position
    return old_article.update_column(:issue_position, old_position) unless old_article.nil?
    false
  end

  def create_position_order
    taken_position = Article.all.where("issue_id = ?", self.issue_id).map(&:issue_position)
    if taken_position.length > 1
      taken_position = (1..taken_position.length+1).to_a - taken_position
      self.update_column(:issue_position, taken_position[0])
    end
  end
end
