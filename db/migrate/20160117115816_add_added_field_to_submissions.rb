class AddAddedFieldToSubmissions < ActiveRecord::Migration
  def change
		  add_column :submissions, :added, :boolean, default: false
  end
end

