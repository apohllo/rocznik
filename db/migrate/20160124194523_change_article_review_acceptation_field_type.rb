class ChangeArticleReviewAcceptationFieldType < ActiveRecord::Migration
  def change
    change_column :article_revisions, :acceptation, :string
  end
end
