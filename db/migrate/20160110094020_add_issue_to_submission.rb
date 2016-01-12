class AddIssueToSubmission < ActiveRecord::Migration
  def change
    add_reference :submissions, :issue, index: true, foreign_key: true
  end
end
