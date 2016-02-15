class ChangeArticleAtributes < ActiveRecord::Migration
  def change
  	change_table :articles do |t|
	t.rename :link_to_article, :external_link
	t.rename :article_pages, :pages
	end
  end
end
