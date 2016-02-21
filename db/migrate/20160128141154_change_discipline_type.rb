class ChangeDisciplineType < ActiveRecord::Migration
  def change
    add_column :people, :discipline_ext, :text, array: true, null: false, default: '{}'
    Person.all.each do |person|
      person.discipline_ext = person.discipline.split(/\s*,\s*/)
      person.save
    end
    remove_column :people, :discipline
    rename_column :people, :discipline_ext, :discipline
  end
end
