class RemoveAddedFromSubmission < ActiveRecord::Migration
  def change
    remove_column :submissions, :added, :boolean
  end
end
