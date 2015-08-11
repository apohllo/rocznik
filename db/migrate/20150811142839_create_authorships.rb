class CreateAuthorships < ActiveRecord::Migration
  def change
    create_table :authorships do |t|
      t.references :person, index: true, foreign_key: true
      t.references :submition, index: true, foreign_key: true
      t.boolean :corresponding, default: true
      t.integer :position, default: 0

      t.timestamps null: false
    end

    add_index :authorships, [:person_id, :submition_id], unique: true
  end
end
