class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sender
      t.string :addressee
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
