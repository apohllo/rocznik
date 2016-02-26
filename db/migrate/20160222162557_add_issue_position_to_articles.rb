class AddIssuePositionToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :issue_position, :integer, :default => 1
  end
end
