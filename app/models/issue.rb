class Issue < ActiveRecord::Base
  validates :year, presence: true, numericality: {greater_than: 2000}
  validates :volume, presence: true, numericality: true, uniqueness: true

  has_many :submissions
  has_many :articles

  scope :published, -> { where(published: true) }
  scope :latest, -> { order("volume desc") }

  def title
    "#{self.volume}\/#{self.year}"
  end

  def submissions_ready?
    !self.submissions.accepted.empty?
  end

  def publish
    self.update_attributes(published: true)
  end

  def prepare_to_publish(ids)
    begin
      self.transaction do
        ids.each do |id|
          submission = Submission.find_by_id(id)
          next unless submission
          Article.create!(submission: submission, issue: self, status: "przygotowany do publikacji")
        end
        self.update_attributes(prepared: true)
      end
      true
    rescue
      false
    end
  end

  def status
    if self.published?
      "Opublikowany"
    elsif self.prepared?
      "Do publikacji"
    else
      ""
    end
  end
end
