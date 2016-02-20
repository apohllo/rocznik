class AddFollowsToSubmissions < ActiveRecord::Migration
  def change
    add_reference :submissions, :follow_up, index: true
  end
end
