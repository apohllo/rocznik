class Review < ActiveRecord::Base
  belongs_to :person
  belongs_to :article_revision

  validates :person_id, presence: true
  validates :article_revision_id, presence: true

  def title
    "#{self.article_revision.title}"
  end

  def reviewer
    self.person.full_name
  end
end
