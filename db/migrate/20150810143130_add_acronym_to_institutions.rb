class AddAcronymToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :acronym, :string
  end
end
