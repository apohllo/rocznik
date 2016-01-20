require 'rails_helper'

RSpec.describe "comments/new", type: :view do
  before(:each) do
    assign(:comment, Comment.new(
      :content => "MyText",
      :person => nil,
      :article_revision => nil
    ))
  end

  it "renders new comment form" do
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do

      assert_select "textarea#comment_content[name=?]", "comment[content]"

      assert_select "input#comment_person_id[name=?]", "comment[person_id]"

      assert_select "input#comment_article_revision_id[name=?]", "comment[article_revision_id]"
    end
  end
end
