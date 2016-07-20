class Person < ActiveRecord::Base
  AUTHOR = "autor"
  EDITOR = "redaktor"
  REVIEWER = "recenzent"

  ROLE_MAP = {
    AUTHOR => "A",
    EDITOR => "E",
    REVIEWER => "R"
  }
  MALE = 'mężczyzna'
  FEMALE = 'kobieta'

  SEX_MAPPING = {
    FEMALE => "K",
    MALE => "M"
  }

  REVIEWER_MAP = {
    "Nowy recenzent" => :new,
    "Recenzuje w terminie" => :reviewsontime,
    "Recenzuje po terminie" => :reviewslate,
    "Nie chce recenzować" => :willnotreview,
    "Chce rezencować" => :willreview
  }

  DISCIPLINE_MAPPING = {
    "filozofia" => "F",
    "psychologia" => "P",
    "socjologia" => "S",
    "lingwistyka" => "L",
    "kognitywistyka" => "K",
    "informatyka" => "I",
    "logika" => "O",
    "neuropsychologia" => "N",
    "etyka" => "E",
    "medycyna" => "M",
    "psychiatria" => "Y"
   }

  UJ = "Uniwersytet Jagielloński"
  POLAND = "Polska"

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :sex, presence: true, inclusion: SEX_MAPPING.keys
  validates :reviewer_status, allow_blank: true, inclusion: REVIEWER_MAP.keys
  validate :roles_inclusion
  validates :degree, format: {with: /(lic\.|inż\.|((mgr\s?(inż\.)?)|((prof\.\s?)?(dr\s?)(hab\.\s?)?(inż\.)?)))/,
    		message: "dopuszczalne: lic., inż., mgr, dr, prof."}, allow_blank: true


  has_many :affiliations, dependent: :destroy
  has_many :authorships, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :submissions, dependent: :restrict_with_error

  scope :all_roles, -> (*roles) { where('roles @> ARRAY[?]',roles) }
  scope :authors, -> { where("roles && ARRAY['#{AUTHOR}']") }
  scope :reviewers, -> { where("roles && ARRAY['#{REVIEWER}']") }
  scope :editors, -> { where("roles && ARRAY['#{EDITOR}']") }

  before_validation -> (record) { record.roles.reject!(&:blank?) }

  def full_name
    "#{self.degree} #{self.name} #{self.surname}"
  end

  def full_name_without_degree
    "#{self.name} #{self.surname}"
  end

  def reverse_full_name
    "#{self.surname}, #{self.name}, #{self.degree}"
  end

  def short_name
    "#{self.name[0]}. #{self.surname}"
  end

  def roles_inclusion
    invalid_role = self.roles.find{|r| !ROLE_MAP.keys.include?(r) }
    if invalid_role
      errors.add(:roles,"'#{invalid_role}' is an invalid role.")
    end
  end

  def current_institutions
    self.affiliations.current.map{|e| e.institution_name }
  end

  def reviews_count
    self.reviews.where.not("status ='recenzja odrzucona' or  status ='wysłano zapytanie'").count
  end

  def congratulations
    self.reviews_count%5 == 0 && self.reviews_count >= 5
  end

  def author!
    self.roles << Person::AUTHOR
    self.save
  end

  def reviewer!
    self.roles << Person::REVIEWER
    self.save
  end

  def reviewer?
    self.roles.include?(REVIEWER)
  end

  def author?
    self.roles.include?(AUTHOR)
  end

  def editor?
    self.roles.include?(EDITOR)
  end

  def from_uj?
    self.affiliations.any? do |affiliation|
      affiliation.institution_name == UJ
    end
  end

  def polish?
    self.affiliations.any? do |affiliation|
      affiliation.country_name == POLAND
    end
  end

  def male?
    self.sex == MALE
  end

  def female?
    self.sex == FEMALE
  end

  def salutation
    if self.male?
      "Szanowny Panie #{self.academic_title}".strip
    elsif self.female?
      "Szanowna Pani #{self.academic_title}".strip
    else
      "Szanowna Pani/Szanowny Panie"
    end
  end

  def gender_name
    if self.male?
      "Pan"
    elsif self.female?
      "Pani"
    else
      "Pan/Pani"
    end
  end

  def academic_title
    result =
      if self.degree
        case self.degree
        when /prof|hab/
          if self.male?
            "Profesorze"
          elsif self.female?
            "Profesor"
          end
        when /dr/
          if self.male?
            "Doktorze"
          elsif self.female?
            "Doktor"
          end
        end
      end
    result = "" if result.nil?
    result
  end
end
