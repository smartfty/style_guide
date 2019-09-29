require 'rails_helper'

RSpec.describe "article_categories/index", type: :view do
  before(:each) do
    assign(:article_categories, [
      ArticleCategory.create!(
        :name => "Name",
        :code => "Code"
      ),
      ArticleCategory.create!(
        :name => "Name",
        :code => "Code"
      )
    ])
  end

  it "renders a list of article_categories" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
  end
end
