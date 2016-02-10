class ChangeNameOfAcceptationFlagInArticleRevisions < ActiveRecord::Migration
  def change
    rename_column :article_revisions, :acceptation, :accepted
  end
end
