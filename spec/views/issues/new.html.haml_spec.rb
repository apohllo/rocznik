require 'rails_helper'

RSpec.describe "issues/new", type: :view do
  before(:each) do
    assign(:issue, Issue.new(
      :year => 1,
      :volume => 1
    ))
  end

  it "renders new issue form" do
    render

    assert_select "form[action=?][method=?]", issues_path, "post" do

      assert_select "input#issue_year[name=?]", "issue[year]"

      assert_select "input#issue_volume[name=?]", "issue[volume]"
    end
  end
end
