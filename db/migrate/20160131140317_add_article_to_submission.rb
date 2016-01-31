class AddArticleToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :article, :string
  end
end
