class AddAcceptationFlagAndCommentToArticleRevision < ActiveRecord::Migration
  def change
    add_column :article_revisions, :acceptation, :string
    add_column :article_revisions, :comment, :text
  end
end
