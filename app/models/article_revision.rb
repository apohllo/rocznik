class ArticleRevision < ActiveRecord::Base
  belongs_to :submission
  has_many :reviews, dependent: :destroy

  validates :submission_id, presence: true
  validates :pages, presence: true, numericality: true
  validates :pictures, presence: true, numericality: true
  validates :version, presence: true, numericality: true

  def title
    "#{self.submission.title}, v. #{self.version}"
  end
end
