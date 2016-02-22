class ArticleRevision < ActiveRecord::Base
  belongs_to :submission
  has_many :reviews, dependent: :destroy
  mount_uploader :article, ArticleUploader

  validates :pages, presence: true, numericality: true
  validates :pictures, presence: true, numericality: true
  validates :version, presence: true, numericality: true
  validates :article, presence: true
  scope :latest, -> { order("created_at desc").first }

  def title
    "#{self.submission.title}, v. #{self.version}"
  end

  def article?
    !!self.article.path
  end

  def finalized_reviews
    self.reviews.finalized
  end

  def file_name
    if article?
      File.basename(self.article.path)
    else
      "[BRAK PLIKU]"
    end
  end

  def authors_institutions
    self.submission.authors_institutions
  end

  def received_date
    if self.received
      self.received.strftime("%d-%m-%Y")
    else
      "[DATA NIEZNANA]"
    end
  end
  
  def editor
    self.submission.person
  end
  
end
