class RemoveAddedFromSubmission < ActiveRecord::Migration
  def change
    if column_exists?(:submissions, :added)
      remove_column :submissions, :added, :boolean
    end
  end
end
