class AddReviewerStatusToPeople < ActiveRecord::Migration
  def change
    add_column :people, :reviewer_status, :string
  end
end

