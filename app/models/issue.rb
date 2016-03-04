class Issue < ActiveRecord::Base
  validates :year, presence: true, numericality: {greater_than: 2000}
  validates :volume, presence: true, numericality: {greater_than: 0}, uniqueness: true

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
          Article.create!(submission: submission, issue: self, status: "po recenzji")
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
  
  def to_param
    [volume, year].join("-")
  end

  def count_uj_submissions
    @count_uj = 0
    self.submissions.each do |submission|
      submission.reviews.each do |review|
        review.person.affiliations.each do |affiliation|
          if affiliation.department.institution.name == "Uniwersytet Jagielloński"
            @count_uj += 1
          end
        end
      end
    end
    return @count_uj
  end

  def count_other_submissions
    @count_other = 0
    self.submissions.each do |submission|
      submission.reviews.each do |review|
        review.person.affiliations.each do |affiliation|
          if affiliation.department.institution.name != "Uniwersytet Jagielloński"
            @count_other += 1
          end
        end
      end
    end
    return @count_other
  end

  def count_uj_percentage
    if count_uj_submissions > 0 or count_other_submissions > 0
      count_uj_submissions*100/(count_uj_submissions + count_other_submissions)
    else
      "0"
    end
  end

  def count_other_percentage
    if count_uj_submissions > 0 or count_other_submissions > 0
      count_other_submissions*100/(count_uj_submissions + count_other_submissions)
    else
      "0"
    end
  end
end
