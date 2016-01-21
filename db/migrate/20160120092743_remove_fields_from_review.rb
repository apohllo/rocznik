class RemoveFieldsFromReview < ActiveRecord::Migration
  def change
    remove_column :reviews, :scope
    remove_column :reviews, :meritum
    remove_column :reviews, :language
    remove_column :reviews, :intelligibility
    remove_column :reviews, :novelty
    remove_column :reviews, :literature
    remove_column :reviews, :general
  end
end
