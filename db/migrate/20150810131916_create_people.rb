class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :surname, null: false, index: true
      t.string :email, null: false, index: true
      t.string :degree, null: false
      t.string :discipline, null: false
      t.string :orcid

      t.timestamps null: false
    end
  end
end
