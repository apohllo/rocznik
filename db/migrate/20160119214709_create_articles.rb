class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :status
      t.string :DOI
    end
    add_reference :articles, :issue, index: true, foreign_key: true
    add_reference :articles, :submission, index: true, foreign_key: true
  end

end
