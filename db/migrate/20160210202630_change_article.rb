class ChangeArticle < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.string :article_pages
      t.string :link_to_article
    end
  end
end
