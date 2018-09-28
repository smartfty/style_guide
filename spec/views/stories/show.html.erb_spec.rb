require 'rails_helper'

RSpec.describe "stories/show", type: :view do
  before(:each) do
    @story = assign(:story, Story.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Subtile/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Path/)
    expect(rendered).to match(/Section/)
  end
end
