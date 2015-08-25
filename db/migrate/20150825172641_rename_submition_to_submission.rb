class RenameSubmitionToSubmission < ActiveRecord::Migration
  def change
    rename_column :article_revisions, :submition_id, :submission_id
    rename_column :authorships, :submition_id, :submission_id
    rename_table :submitions, :submissions
  end
end
