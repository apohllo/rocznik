class AddCodeToArticleRevisions < ActiveRecord::Migration
  def change
    add_column :article_revisions, :code, :string, default: "tekst_"
  end
end
