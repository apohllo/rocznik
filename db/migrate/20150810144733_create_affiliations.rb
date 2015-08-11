class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.references :person, index: true, foreign_key: true
      t.references :department, index: true, foreign_key: true
      t.integer :year_from
      t.integer :year_to

      t.timestamps null: false
    end

    add_index :affiliations, [:person_id,:department_id], unique: true
  end
end
