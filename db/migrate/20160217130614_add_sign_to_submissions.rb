class AddSignToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :signed, :boolean, :default => false
  end
end
