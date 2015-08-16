class ArticleRevision < ActiveRecord::Base
  belongs_to :submition
  has_many :reviews, dependent: :destroy

  validates :submition_id, presence: true
  validates :pages, presence: true, numericality: true
  validates :pictures, presence: true, numericality: true
  validates :version, presence: true, numericality: true

  def title
    "#{self.submition.title}, v. #{self.version}"
  end
end
