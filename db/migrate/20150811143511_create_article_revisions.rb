class CreateArticleRevisions < ActiveRecord::Migration
  def change
    create_table :article_revisions do |t|
      t.references :submition, index: true, foreign_key: true
      t.integer :version, default: 1
      t.date :received
      t.integer :pages
      t.integer :pictures, default: 0

      t.timestamps null: false
    end
  end
end
