class AddAuthorRoleToAuthorship < ActiveRecord::Migration
  def change
    add_column :authorships, :role, :string
  end
end

