class AddFollowsToSubmissions < ActiveRecord::Migration
  def change
    add_reference :submissions, :follows_up, index: true
  end
end
