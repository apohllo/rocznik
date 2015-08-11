class CreateSubmitions < ActiveRecord::Migration
  def change
    create_table :submitions do |t|
      t.string :status
      t.string :polish_title
      t.string :english_title
      t.text :polish_abstract
      t.text :english_abstract
      t.string :polish_keywords
      t.string :english_keywords
      t.text :remarks
      t.text :funding
      t.date :received
      t.string :language

      t.timestamps null: false
    end
  end
end
