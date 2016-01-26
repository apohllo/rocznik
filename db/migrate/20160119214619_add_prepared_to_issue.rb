class AddPreparedToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :prepared, :boolean, default: false
  end
end

