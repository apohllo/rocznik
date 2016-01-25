class AddCompetenceToPeople < ActiveRecord::Migration
  def change
    add_column :people, :competence, :text
  end
end
