class ArticleRevision < ActiveRecord::Base
  belongs_to :submition

  validates :submition_id, presence: true
  validates :version, presence: true, numericality: true

  def title
    "#{self.submition.full_title}, v. #{self.version}"
  end
end
