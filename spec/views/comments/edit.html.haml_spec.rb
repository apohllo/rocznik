require 'rails_helper'

RSpec.describe "comments/edit", type: :view do
  before(:each) do
    @comment = assign(:comment, Comment.create!(
      :content => "MyText",
      :person => nil,
      :article_revision => nil
    ))
  end

  it "renders the edit comment form" do
    render

    assert_select "form[action=?][method=?]", comment_path(@comment), "post" do

      assert_select "textarea#comment_content[name=?]", "comment[content]"

      assert_select "input#comment_person_id[name=?]", "comment[person_id]"

      assert_select "input#comment_article_revision_id[name=?]", "comment[article_revision_id]"
    end
  end
end
