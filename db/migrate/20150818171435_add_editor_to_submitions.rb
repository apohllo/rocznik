class AddEditorToSubmitions < ActiveRecord::Migration
  def change
    add_reference :submitions, :person, index: true, foreign_key: true
  end
end
