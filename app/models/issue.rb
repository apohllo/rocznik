class Issue < ActiveRecord::Base
	has_many :submissions
end
