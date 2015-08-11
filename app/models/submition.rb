# encoding: utf-8

class Submition < ActiveRecord::Base
  validates :status, inclusion: %w{nadesłany}
  validates :language, inclusion: %w{polski angielski}
  has_many :authorships, dependent: :destroy

  MAX_LENGTH = 80

  def title
    if !self.polish_title.blank?
      if self.polish_title.size > MAX_LENGTH
        self.polish_title[0...MAX_LENGTH] + "..."
      else
        self.polish_title
      end
    elsif !self.english_title.blank?
      if self.english_title.size > MAX_LENGTH
        self.english_title[0...MAX_LENGTH] + "..."
      else
        self.english_title
      end
    else
      "[BRAK TYTUŁU]"
    end
  end

  def corresponding_author
    authorship = self.authorships.where(corresponding: true).first
    if authorship
      authorship.author
    else
      "[BRAK AUTORA]"
    end
  end

  def full_title
    "#{corresponding_author}, #{title}"
  end
end
