class Person < ActiveRecord::Base

  ROLE_MAP = {
    "autor" => "A",
    "redaktor" => "E",
    "recenzent" => "R"
  }

  SEX_MAPPING = {
    "kobieta" => "K",
    "mężczyzna" => "M"
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

  mount_uploader :photo, PhotoUploader

  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true
  validates :sex, presence: true, inclusion: SEX_MAPPING.keys
  validates :reviewer_status, allow_blank: true, inclusion: REVIEWER_MAP.keys
  validate :roles_inclusion


  has_many :affiliations, dependent: :destroy
  has_many :authorships, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :submissions, dependent: :restrict_with_error

  scope :all_roles, -> (*roles) { where('roles @> ARRAY[?]',roles) }
  scope :authors, -> { where("roles && ARRAY['autor']") }
  scope :reviewers, -> { where("roles && ARRAY['recenzent']") }
  scope :editors, -> { where("roles && ARRAY['redaktor']") }

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
      errors.add(:roles,"'#{invalid_role}' is a invalid role.")
    end
  end

  def current_institutions
    self.affiliations.current.map{|e| e.institution}
  end


  def reviewer?
    self.roles.include?("recenzent")
  end
  
end
