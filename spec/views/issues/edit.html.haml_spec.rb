require 'rails_helper'

RSpec.describe "issues/edit", type: :view do
  before(:each) do
    @issue = assign(:issue, Issue.create!(
      :year => 1,
      :volume => 1
    ))
  end

  it "renders the edit issue form" do
    render

    assert_select "form[action=?][method=?]", issue_path(@issue), "post" do

      assert_select "input#issue_year[name=?]", "issue[year]"

      assert_select "input#issue_volume[name=?]", "issue[volume]"
    end
  end
end
