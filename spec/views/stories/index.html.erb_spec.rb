require 'rails_helper'

RSpec.describe "stories/index", type: :view do
  before(:each) do
    assign(:stories, [
      Story.create!(
        :user => nil,
        :working_article => nil,
        :title => "Title",
        :subtile => "Subtile",
        :body => "MyText",
        :quoute => "MyText",
        :status => "Status",
        :char_count => 2,
        :published => false,
        :path => "Path",
        :section => "Section"
      ),
      Story.create!(
        :user => nil,
        :working_article => nil,
        :title => "Title",
        :subtile => "Subtile",
        :body => "MyText",
        :quoute => "MyText",
        :status => "Status",
        :char_count => 2,
        :published => false,
        :path => "Path",
        :section => "Section"
      )
    ])
  end

  it "renders a list of stories" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Subtile".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Path".to_s, :count => 2
    assert_select "tr>td", :text => "Section".to_s, :count => 2
  end
end
