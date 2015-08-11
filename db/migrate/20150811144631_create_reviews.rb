class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :person, index: true, foreign_key: true
      t.references :article_revision, index: true, foreign_key: true
      t.string :status
      t.date :asked
      t.date :deadline
      t.text :content
      t.integer :scope
      t.integer :meritum
      t.integer :language
      t.integer :intelligibility
      t.integer :novelty
      t.integer :literature
      t.integer :general
      t.text :remarks

      t.timestamps null: false
    end
  end
end
