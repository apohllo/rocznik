class RemovePolishAbstractFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :polish_abstract, :text
  end
end
