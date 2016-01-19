class AddSexToPerson < ActiveRecord::Migration
  def change
    add_column :people, :sex, :string
  end
end
