class AddAuthorRoleToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :author_role, :string
  end
end
