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

  def authors_count(type)
    self.author_division[type]
  end

  def total_authors_count
    authors_count(:polish) + authors_count(:foreign)
  end

  def authors_percentage(type)
    percentage(self.author_division[type],self.total_authors_count)
  end

  def submissions_count(type)
    case type
    when :english
      self.submissions.english.count
    when :polish
      self.submissions.polish.count
    else
      raise "Invalid submission type '#{type}'"
    end
  end

  def total_submissions_count
    submissions_count(:polish) + submissions_count(:english)
  end

  def submissions_percentage(type)
    percentage(submissions_count(type),total_submissions_count)
  end

  def reviewers_count(type)
    case type
    when :uj, :other
      institution_division[type]
    when :polish, :foreign
      reviewers_division[type]
    else
      raise "Invalid reviewer type '#{type}'"
    end
  end

  def reviewers_count_by_country
    reviewers_count(:polish) + reviewers_count(:foreign)
  end

  def reviewers_count_by_institution
    reviewers_count(:polish) + reviewers_count(:foreign)
  end

  def reviewers_percentage(type)
    case type
    when :polish, :foreign
      percentage(reviewers_count(type),reviewers_count_by_country)
    when :uj, :other
      percentage(reviewers_count(type),reviewers_count_by_institution)
    else
      raise "Invalid reviewer type '#{type}'"
    end
  end

  protected
  def percentage(count,total)
    if total > 0
      (count  * 100 / total).round
    else
      0
    end
  end

  def unique_reviewers
    self.articles.flat_map{|a| a.reviews.select(&:done?).flat_map{|r| r.person } }.uniq
  end

  def institution_division
    return @institution_division if @institution_division
    @institution_division = Hash.new(0)
    self.unique_reviewers.each do |reviewer|
      reviewer.affiliations.each do |affiliation|
        if affiliation.institution == "Uniwersytet Jagielloński"
          @institution_division[:uj] += 1
        else
          @institution_division[:other] += 1
        end
      end
    end
    @institution_division
  end

  def author_division
    return @author_division if @author_division
    @author_division = Hash.new(0)
    self.articles.each do |article|
      article.authors.each do |author|
        author.affiliations.each do |affiliation|
          if affiliation.country_name == "Polska"
            @author_division[:polish] += 1
          else
            @author_division[:foreign] += 1
          end
        end
      end
    end
    @author_division
  end

  def reviewers_division
    return @reviewers_division if @reviewers_division
    @reviewers_division = Hash.new(0)
    self.unique_reviewers.each do |reviewer|
      reviewer.affiliations.each do |affiliation|
        if affiliation.country_name == "Polska"
          @reviewers_division[:polish] += 1
        else
          @reviewers_division[:foreign] += 1
        end
      end
    end
    @reviewers_division
  end
end
