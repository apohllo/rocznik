class RemoveConstraintsOnPerson < ActiveRecord::Migration
  def change
    change_column :people, :degree, :string, null: true
    add_column :people, :status, :text, array: true, null: false, default: '{}'
  end
end
