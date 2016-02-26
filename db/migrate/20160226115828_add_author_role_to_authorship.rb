class AddAuthorRoleToAuthorship < ActiveRecord::Migration
  def change
    add_column :authorships, :author_role, :text
  end
end

