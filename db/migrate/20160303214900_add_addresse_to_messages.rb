class AddAddresseToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :addresse, :string
  end
end
