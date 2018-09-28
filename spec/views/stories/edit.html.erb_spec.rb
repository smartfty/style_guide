require 'rails_helper'

RSpec.describe "stories/edit", type: :view do
  before(:each) do
    @story = assign(:story, Story.create!(
      :user => nil,
      :working_article => nil,
      :title => "MyString",
      :subtile => "MyString",
      :body => "MyText",
      :quoute => "MyText",
      :status => "MyString",
      :char_count => 1,
      :published => false,
      :path => "MyString",
      :section => "MyString"
    ))
  end

  it "renders the edit story form" do
    render

    assert_select "form[action=?][method=?]", story_path(@story), "post" do

      assert_select "input[name=?]", "story[user_id]"

      assert_select "input[name=?]", "story[working_article_id]"

      assert_select "input[name=?]", "story[title]"

      assert_select "input[name=?]", "story[subtile]"

      assert_select "textarea[name=?]", "story[body]"

      assert_select "textarea[name=?]", "story[quoute]"

      assert_select "input[name=?]", "story[status]"

      assert_select "input[name=?]", "story[char_count]"

      assert_select "input[name=?]", "story[published]"

      assert_select "input[name=?]", "story[path]"

      assert_select "input[name=?]", "story[section]"
    end
  end
end
