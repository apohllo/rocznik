class AddRolesToPeople < ActiveRecord::Migration
  def change
    add_column :people, :roles, :text, array: true, null: false, default: '{}'
  end
end
