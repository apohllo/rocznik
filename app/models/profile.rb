class Profile < ActiveRecord::Base
  belongs_to :person
  
  validates :name, presence: true
  validates :surname, presence: true
  validates :discipline, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence:true
  
end