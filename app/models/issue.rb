class Issue < ActiveRecord::Base
  validates :year, presence: true, numericality: true
  validates :volume, presence: true, numericality: true

  has_many :submissions
  has_many :articles

  def title
    "#{self.volume}\/#{self.year}"
  end

  def submissions_ready?
    !self.submissions.accepted.empty?
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
end
