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

  def authors_count(type,scope)
    self.author_division(scope)[type]
  end

  def total_authors_count(scope)
    authors_count(:polish, scope) + authors_count(:foreign, scope)
  end

  def authors_percentage(type, scope)
    percentage(self.author_division(scope)[type], self.total_authors_count(scope))
  end

  def submissions_count(type,scope)
    case scope
    when :all
      case type
      when :english
        self.submissions.english.count
      when :polish
        self.submissions.polish.count
      else
        raise "Invalid submission type '#{type}'"
      end
    when :accepted
      case type
      when :english
        self.articles.english.count
      when :polish
        self.articles.polish.count
      else
        raise "Invalid submission type '#{type}'"
      end
    else
      raise "Invalid submission scope '#{scope}'"
    end
  end

  def total_submissions_count(scope)
    submissions_count(:polish,scope) + submissions_count(:english,scope)
  end

  def submissions_percentage(type,scope)
    percentage(submissions_count(type,scope),total_submissions_count(scope))
  end

  def reviewers_count(type,scope)
    case type
    when :uj, :other
      institution_division(scope)[type]
    when :polish, :foreign
      reviewers_division(scope)[type]
    else
      raise "Invalid reviewer type '#{type}'"
    end
  end

  def reviewers_count_by_country(scope)
    reviewers_count(:polish,scope) + reviewers_count(:foreign,scope)
  end

  def reviewers_count_by_institution(scope)
    reviewers_count(:polish,scope) + reviewers_count(:foreign,scope)
  end

  def reviewers_percentage(type,scope)
    case type
    when :polish, :foreign
      percentage(reviewers_count(type,scope),reviewers_count_by_country(scope))
    when :uj, :other
      percentage(reviewers_count(type,scope),reviewers_count_by_institution(scope))
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

  def unique_reviewers(scope)
    collection =
      if scope == :all
        self.submissions
      else
        self.articles
      end
    collection.flat_map{|a| a.reviews.select(&:done?).flat_map{|r| r.person } }.uniq
  end

  def institution_division(scope)
    return @institution_division[scope] if @institution_division && @institution_division[scope]
    @institution_division ||= {}
    @institution_division[scope] = Hash.new(0)
    self.unique_reviewers(scope).each do |reviewer|
      if reviewer.from_uj?
        @institution_division[:uj] += 1
      else
        @institution_division[:other] += 1
      end
    end
    @institution_division
  end

  def author_division(scope)
    return @author_division[scope] if @author_division && @author_division[scope]
    @author_division ||= {}
    @author_division[scope] = Hash.new(0)
    if scope == :all
      collection = self.submissions
    else
      collection = self.articles
    end
    authors = collection.flat_map{|i| i.authors }.uniq
    authors.each do |author|
      if author.polish?
        @author_division[scope][:polish] += 1
      else
        @author_division[scope][:foreign] += 1
      end
    end
    @author_division[scope]
  end

  def reviewers_division(scope)
    return @reviewer_division[scope] if @reviewer_division && @reviewer_division[scope]
    @reviewer_division ||= {}
    @reviewer_division[scope] = Hash.new(0)
    self.unique_reviewers(scope).each do |reviewer|
      if reviewer.polish?
        @reviewer_division[:polish] += 1
      else
        @reviewer_division[:foreign] += 1
      end
    end
    @reviewer_division[scope]
  end
end
