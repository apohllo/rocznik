class AddSignToAuthorships < ActiveRecord::Migration
  def change
    add_column :authorships, :signed, :boolean, :default => false
  end
end
