class AddArticleToArticleRevision < ActiveRecord::Migration
  def change
    add_column :article_revisions, :article, :string
  end
end
