class AddSubmissionRefToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :submission, index: true, foreign_key: true
  end
end
