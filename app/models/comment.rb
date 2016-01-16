class Comment < ActiveRecord::Base
  belongs_to :person
  belongs_to :article_revision

  validates :person_id, presence: true
  validates :article_revision_id, presence: true
end
