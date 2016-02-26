class AddAuthorRoleToAuthorship < ActiveRecord::Migration
  def change
    add_reference :authorships, :author_role, index: true
  end
end

