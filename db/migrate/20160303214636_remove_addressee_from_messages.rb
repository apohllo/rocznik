class RemoveAddresseeFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :addressee, :string
  end
end
