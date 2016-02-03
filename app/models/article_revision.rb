class ArticleRevision < ActiveRecord::Base
  belongs_to :submission
  has_many :reviews, dependent: :destroy
  mount_uploader :article, ArticleUploader

  ACCEPT_MAPPING = {
    "tak" => "tak",
    "nie" => "nie"
  }

  validates :submission_id, presence: true
  validates :pages, presence: true, numericality: true
  validates :pictures, presence: true, numericality: true
  validates :version, presence: true, numericality: true

  def title
    "#{self.submission.title}, v. #{self.version}"
  end

  def article?
    !!self.article.path
  end

  def file_name
    if article?
      File.basename(self.article.path)
    else
      "[BRAK PLIKU]"
    end
  end
end
