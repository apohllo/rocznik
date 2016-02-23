class ChangeSubmissionMigrates < ActiveRecord::Migration
  def change
  	change_table :submissions do |t|
      t.rename :follows_up_id, :follow_up
  	end
  end
end

