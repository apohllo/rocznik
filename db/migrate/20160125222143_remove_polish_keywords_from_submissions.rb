class RemovePolishKeywordsFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :polish_keywords, :text
  end
end
