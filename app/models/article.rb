class Article < ActiveRecord::Base
  belongs_to :issue
  belongs_to :submission
end
