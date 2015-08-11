class ChangePersonStatus < ActiveRecord::Migration
  def change
    remove_column :people, :status
  end
end
