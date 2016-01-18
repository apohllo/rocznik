class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :year
      t.integer :volume

      t.timestamps null: false
    end
  end
end
